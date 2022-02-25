import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/person.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/data/services/persons.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/person/person_view.dart';
import 'package:notaemato/ui/widgets/app_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class PersonsAndDevicesViewModel extends ReactiveViewModel {
  PersonsAndDevicesViewModel(BuildContext context) {
    navigator = Navigator.of(context);
  }
  @override
  List<ReactiveServiceMixin> get reactiveServices => [devicesService, personsService];
  // Services
  final DevicesService devicesService = locator<DevicesService>();
  final SocketApi api = locator<SocketApi>();
  final PersonsService personsService = locator<PersonsService>();
  late NavigatorState navigator;

  // Constants

  // Controllers

  // Variables
  List<DeviceModel> get devices => devicesService.devices.val!;
  List<PersonModel> get persons => personsService.rawPersons.val!;

  // Logic

  Future onReady() async {}

  Future<bool> onWillPop() async {
    //TODO: check empty devices => show modal
    return true;
  }

  Future<DeviceModel> getDeviceFromPerson(int personId) async {
    return devices.firstWhere((element) => element.personId == personId);
  }

  PersonModel getPerson(int id) {
    return persons.firstWhere((element) => element.personId == id);
  }

  Future<void> deletePerson(PersonModel person) async {
    final ref = await api.deletePersonProfile(person.personId);
    if (ref == 0) return personsService.update(force: true);
    if (ref != 0) return;
  }

  Future<void> onMenuTap(BuildContext context, PersonModel person) async {
    MetricaService.event('persons_menu_tap', {'personId': person.personId});
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () {
              MetricaService.event('persons_edit_tap', {'personId': person.personId});
              Navigator.of(context).pop(true);
              navigator.push(PersonViewRoute(person: person));
            },
            child: const Text('Редактировать персону'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              MetricaService.event('persons_delete_tap', {'personId': person.personId});
              Navigator.of(context).pop();
              final delete = await showAppDialog<String>(
                title: 'Удаление персоны',
                subtitle: 'Вы уверены?',
                actionTitle: 'Удалить',
              );
              if (delete == 'Удалить') deletePerson(person);
            },
            child: const Text(
              'Удалить персону',
              style: TextStyle(color: AppColors.red),
            ),
          )
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
}
