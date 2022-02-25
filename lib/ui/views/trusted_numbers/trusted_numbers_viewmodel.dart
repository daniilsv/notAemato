import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/dto/socket_error.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/views/add_number/add_number_view.dart';
import 'package:notaemato/ui/views/edit_contact/edit_contact_view.dart';
import 'package:notaemato/ui/views/trusted_numbers/views/sos_phones_view.dart';
import 'package:notaemato/ui/widgets/app_dialog.dart';
import 'package:notaemato/ui/widgets/switch_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';

class TrustedNumbersViewModel extends ReactiveViewModel {
  TrustedNumbersViewModel(BuildContext context) {
    navigator = Navigator.of(context);
    device = ModalRoute.of(context)!.settings.arguments! as DeviceModel;
  }
  @override
  List<ReactiveServiceMixin> get reactiveServices => [devicesService];
  // Services
  late NavigatorState navigator;
  final DevicesService devicesService = locator<DevicesService>();
  final SocketApi api = locator<SocketApi>();

  // Constants

  // Controllers

  // Variables
  List<PhonebookPhone> phonebook = [];
  List<SosPhone> get sosPhones =>
      devicesService.devices.val!
          .firstWhere((element) => element == device)
          .deviceProps!
          .sosPhones ??
      [];
  late DeviceModel device;
  // Logic

  Future onReady() async {
    setBusy(true);
    device = devicesService.devices.val!.firstWhere((element) => element == device);
    phonebook = devicesService.devices.val!
            .firstWhere((element) => element == device)
            .deviceProps!
            .phonebook ??
        [];
    setBusy(false);
    notifyListeners();
  }

  Future<bool> onWillPop() async {
    //TODO: check empty devices => show modal
    return true;
  }

  void onPop() {
    navigator.pop(phonebook);
  }

  Future<void> onSosTap() async {
    MetricaService.event('sos_tap', {'oid': device.oid});
    navigator.push(SosPhonesViewRoute(device));
  }

  Future<void> onReject(BuildContext context, int index) async {
    final p = phonebook[index];
    // sosPhones.removeWhere((element) => element.phone == phonebook[index].phone);
    phonebook.removeAt(index);
    setBusy(true);
    try {
      final ret = await api.setObjectPhonebook(device.oid, phonebook);
      logger.i(ret);
      if (ret == 0) {
        //TODO: check here
        if (sosPhones.indexWhere((element) => element.phone == p.phone) != -1) {
          sosPhones.removeWhere((element) => element.phone == p.phone);
          final ret = await api.setObjectSosPhones(device.oid, sosPhones);
          logger.i(ret);
          if (ret == 0) {
            setBusy(false);
            await devicesService.update(force: true);
          }
        }

        await devicesService.update(force: true);
      }
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        // проверьте интернет
        final retry = await showAppDialog(
          title: Strings.current.device_not_added,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        setBusy(false);
        if (retry == true) {
          phonebook.insert(index, p);
          onReject(context, index);
        } else {
          phonebook.insert(index, p);
        }
        return;
      }
      switchError(e.error);
      phonebook.insert(index, p);
    } finally {
      setBusy(false);
    }
    notifyListeners();
  }

  int getSosNumber(String? phone) {
    return sosPhones.indexWhere((element) => element.phone == phone) + 1;
  }

  Future<void> onAddNumberTap(BuildContext context) async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      final PhonebookPhone? contact = await navigator.push(AddNumberViewRoute());
      if (contact == null) return;
      phonebook.add(
        PhonebookPhone(phone: contact.phone, name: contact.name),
      );
      MetricaService.event('trusted_add_phone', {'oid': device.oid});
      await save();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('Доступ к контактам'),
          content: Text(
              'Ранее Вы запретили доступ. Приложению нужен доступ к контактам чтобы Вы могли выбрать доверенный номер. Дайте соответствуйщее разрешение в настройках приложения.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Отменить'),
              onPressed: () => navigator.pop(),
            ),
            CupertinoDialogAction(
              child: Text('Настройки'),
              onPressed: () {
                openAppSettings();
                navigator.pop();
              },
            ),
          ],
        ),
      );
    }
    notifyListeners();
  }

  Future<PermissionStatus> _getPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      permission = await Permission.contacts.request();
    }
    return permission;
  }

  Future<void> save() async {
    setBusy(true);
    try {
      final ret = await api.setObjectPhonebook(device.oid, phonebook);
      logger.i(ret);
      if (ret == 0) {
        await devicesService.update(force: true);
      }
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        final retry = await showAppDialog<String>(
          title: Strings.current.device_not_added,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == Strings.current.retry) {
          save();
        }
        return;
      }
      switchError(e.error);
      phonebook.removeLast();
    } finally {
      setBusy(false);
    }
    notifyListeners();
  }

  Future<void> onPhoneTap(int index) async {
    final ret = await navigator.push(EditContactViewRoute(phonebook[index]));
    if (ret == null) return;
    phonebook.removeAt(index);
    phonebook.insert(index, ret);
    save();
  }
}
