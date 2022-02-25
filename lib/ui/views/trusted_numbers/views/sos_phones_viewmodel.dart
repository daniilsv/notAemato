import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/dto/socket_error.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/widgets/app_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class SosPhonesViewModel extends ReactiveViewModel {
  SosPhonesViewModel(BuildContext context) {
    navigator = Navigator.of(context);
    device = ModalRoute.of(context)!.settings.arguments! as DeviceModel;
  }
  @override
  List<ReactiveServiceMixin> get reactiveServices => [devicesService];
  // Services
  late NavigatorState navigator;
  final SocketApi api = locator<SocketApi>();
  final DevicesService devicesService = locator<DevicesService>();

  // Constants

  // Controllers

  // Variables
  List<PhonebookPhone> initial = [];
  List<PhonebookPhone> get phonebook => device.deviceProps?.phonebook ?? [];
  List<SosPhone>? sosPhones = [];
  late DeviceModel device;

  // Logic

  Future onReady() async {
    device = devicesService.devices.val!.firstWhere((element) => element == device);
    sosPhones = devicesService.devices.val!
        .firstWhere((element) => element == device)
        .deviceProps!
        .sosPhones;
    notifyListeners();
  }

  Future<void> onSosSelect(BuildContext context, PhonebookPhone phone) async {
    final ret = await showCupertinoModalPopup<int>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => CupertinoActionSheet(
          title: Text('Выбрать порядковый номер'),
          actions: <Widget>[
            if (phonebook.isNotEmpty &&
                sosPhones!.indexWhere((element) => element.phone == phone.phone) != 0)
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.of(context).pop(0);
                },
                child: const Text('1'),
              ),
            if (phonebook.length > 1 &&
                sosPhones!.isNotEmpty &&
                sosPhones!.indexWhere((element) => element.phone == phone.phone) != 1)
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.of(context).pop(1);
                },
                child: const Text('2'),
              ),
            if (phonebook.length > 2 &&
                sosPhones!.length > 1 &&
                sosPhones!.indexWhere((element) => element.phone == phone.phone) != 2 &&
                sosPhones!.length - 2 !=
                    sosPhones!.indexWhere((element) => element.phone == phone.phone))
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.of(context).pop(2);
                },
                child: const Text('3'),
              ),
            if (sosPhones!.isNotEmpty &&
                sosPhones!.contains(sosPhones!.firstWhere(
                    (element) => element.phone == phone.phone,
                    orElse: () => SosPhone())))
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.of(context).pop(4);
                },
                child: const Text('Убрать'),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Отмена'),
          )),
    );

    if (ret == null) return;
    if (ret == 4) {
      sosPhones!.removeWhere((element) => element.phone == phone.phone);
      notifyListeners();
      return;
    }
    if (sosPhones!.isNotEmpty && sosPhones!.length - 1 >= ret)
    sosPhones!.removeAt(ret);
    sosPhones!.insert(ret, SosPhone(phone: phone.phone));
    notifyListeners();
  }

  int getSosNumber(String? phone) {
    return sosPhones!.indexWhere((element) => element.phone == phone) + 1;
  }

  Future<void> save() async {
    setBusy(true);
    try {
      final ret = await api.setObjectSosPhones(device.oid, sosPhones);
      logger.i(ret);
      if (ret == 0) {
        await devicesService.update(force: true);
        setBusy(false);
        navigator.pop();
      }
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        // проверьте интернет
        final retry = await showAppDialog<String>(
          title: 'Нет связи',
          subtitle: 'Проверьте интернет соединение',
          actionTitle: Strings.current.retry,
        );
        if (retry ==  Strings.current.retry) save();
        setBusy(false);
        return;
      }
      switch (e.error) {
        case 4002: // проверьте код
          final retry = await showAppDialog(
            title: 'Устройство не отвечает',
            subtitle: '',
            actionTitle: Strings.current.retry,
          );
          if (retry == true) save();
          setBusy(false);
          break;
        case 4000: // проверьте код
          final retry = await showAppDialog(
            title: 'Устройство не отвечает',
            subtitle: '',
            actionTitle: Strings.current.retry,
          );
          if (retry == true) save();
          setBusy(false);
          break;
      }
    } finally {
      setBusy(false);
    }
  }

  Future<void> deleteSosNumbers() async {
    setBusy(true);
    try {
      final ret = await api.setObjectSosPhones(device.oid, []);
      logger.i(ret);
      if (ret == 0) {
        setBusy(false);
        navigator.pop();
      }
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        // проверьте интернет
        final retry = await showAppDialog(
          title: 'Нет связи',
          subtitle: 'Проверьте интернет соединение',
          actionTitle: Strings.current.retry,
        );
        if (retry == true) save();
        setBusy(false);
        return;
      }
      switch (e.error) {
        case 4002: // проверьте код
          final retry = await showAppDialog(
            title: 'Устройство не отвечает',
            subtitle: '',
            actionTitle: Strings.current.retry,
          );
          if (retry == true) save();
          setBusy(false);
          break;
      }
    } finally {
      setBusy(false);
    }
  }
}
