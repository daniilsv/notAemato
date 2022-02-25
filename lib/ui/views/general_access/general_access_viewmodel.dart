import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/dto/socket_error.dart';
import 'package:notaemato/data/model/enum/is_accepted.dart';
import 'package:notaemato/data/model/person.dart';
import 'package:notaemato/data/model/person_access_request.dart';
import 'package:notaemato/data/model/user.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/data/services/persons.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/widgets/app_dialog.dart';
import 'package:notaemato/ui/widgets/switch_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class GeneralAccessViewModel extends BaseViewModel {
  GeneralAccessViewModel(BuildContext context) {
    navigator = Navigator.of(context);
  }
  // Services
  final SocketApi api = locator<SocketApi>();
  final PersonsService personsService = locator<PersonsService>();
  NavigatorState? navigator;

  // Constants

  List<PersonAccessRequest> allUsers = [];
  List<PersonAccessRequest> newUsers = [];
  Map<UserModel, List<PersonAccessRequest>> rejectedUsers = {};
  Map<UserModel, List<PersonAccessRequest>> trustUsers = {};
  List<PersonModel> get persons => personsService.rawPersons.val!;
  Map<int, PersonModel> get personsMap => personsService.persons;

  // Controllers

  // Variables

  // Logic

  Future onReady() async {
    await api.clearShareBadgeCounter();
    await getUsers();
  }

  Future<void> getUsers() async {
    newUsers.clear();
    trustUsers.clear();
    rejectedUsers.clear();
    try {
      allUsers
        ..clear()
        ..addAll((await api.getPersonAccessRequests())!);
      for (final u in allUsers) {
        if (u.personId != null) {
          final user = UserModel(
              photo: u.userPhotoUrl,
              skytag: '${u.userName} (${u.roleTitle})',
              email: u.email);

          if (u.isAccepted == IsAccepted.waiting) {
            newUsers.add(u);
          }
          if (u.isAccepted == IsAccepted.active) {
            if (!trustUsers.containsKey(user)) trustUsers[user] = [];
            trustUsers[user]!.add(u);
          }
          if (u.isAccepted == IsAccepted.declined) {
            if (!rejectedUsers.containsKey(user)) rejectedUsers[user] = [];
            rejectedUsers[user]!.add(u);
          }
        }
      }
    } finally {}
    notifyListeners();
  }

  String getPersonsName(List<PersonAccessRequest>? users) {
    return users?.map((e) => personsMap[e.personId]?.name ?? '').join(', ') ?? '';
  }

  Future<void> onAccept(BuildContext context, PersonAccessRequest request) async {
    processPersonAccessRequest(
        request: request, isAccepted: IsAccepted.active);
  }

  Future<void> onReject(BuildContext context, PersonAccessRequest request) async {
    processPersonAccessRequest(
        request: request, isAccepted: IsAccepted.declined);
  }

  Future<void> onMenuTap({
    required BuildContext context,
    required List<PersonAccessRequest> requests,
    required IsAccepted isAccepted,
  }) async {
    MetricaService.event('access_menu_tap', {'personId': requests.first.personId});
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.of(context).pop();
              setBusy(true);
              try {
                for (final r in requests) {
                  await api.processPersonAccessRequest(r.personAccessId,
                      isAccepted: isAccepted);
                }
              } finally {
                setBusy(false);
                onReady();
              }
            },
            child: Text(isAccepted == IsAccepted.active
                ? 'Предоставить доступ'
                : 'Отозвать доступ'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Отмена'),
        ),
      ),
    );
  }

  Future<void> processPersonAccessRequest({
    required PersonAccessRequest request,
    required IsAccepted isAccepted,
  }) async {
    MetricaService.event('access_process_tap', {'personId': request.personId});
    setBusy(true);
    try {
      final ret = await api.processPersonAccessRequest(request.personAccessId,
          isAccepted: isAccepted);
      logger.i(ret);
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        final retry = await showAppDialog(
          title: Strings.current.error,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == Strings.current.retry)
          processPersonAccessRequest(
            request: request,
            isAccepted: isAccepted,
          );
        return;
      }
      switchError(e.error);
    } finally {
      setBusy(false);
      onReady();
    }
  }
}
