import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/dto/socket_error.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/views/trusted_numbers/trusted_numbers_view.dart';
import 'package:notaemato/ui/widgets/app_dialog.dart';
import 'package:notaemato/ui/widgets/switch_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class SettingsViewModel extends ReactiveViewModel {
  SettingsViewModel(BuildContext context) {
    initial = ModalRoute.of(context)!.settings.arguments! as DeviceModel;
    navigator = Navigator.of(context);
  }
  @override
  List<ReactiveServiceMixin> get reactiveServices => [devicesService];
  // Services
  late NavigatorState navigator;
  final SocketApi api = locator<SocketApi>();
  final DevicesService devicesService = locator<DevicesService>();

  // Constants

  // Variables
  late DeviceModel initial;
  DeviceModel get device =>
      devicesService.devices.val!.firstWhere((element) => element == initial);

  // Controllers
  final trustedController = TextEditingController();
  final timeZoneController = TextEditingController();
  final phoneController = TextEditingController();
  final modeController = TextEditingController();

  // Variables

  // Logic

  Future onReady() async {
    trustedController.text = device.deviceProps!.phonebook!.isNotEmpty
        ? '${device.deviceProps!.phonebook!.length} ${getStringForNumbersLength(device.deviceProps!.phonebook!.length)}'
        : '';
    timeZoneController.text = device.deviceProps!.timezone!;
    phoneController.text = device.deviceProps!.simNumber1!;
    modeController.text = getStringCheckinPeriod(device.deviceProps!.checkinPeriod);
    notifyListeners();
  }

  Future onModeTap(BuildContext context) async {
    final ret = await showCupertinoModalPopup<int>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.of(context).pop(1);
            },
            child: Text('Постоянный режим'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.of(context).pop(2);
            },
            child: Text('Нормальный режим'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.of(context).pop(3);
            },
            child: Text('Экономный режим'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            navigator.pop();
          },
          child: const Text('Отмена'),
        ),
      ),
    );
    if (ret == null) return;
    setObjectCheckinPeriod(ret);
    notifyListeners();
  }

  Future onTimeZoneTap() async {
    MetricaService.event('device_timezone_tap', {'oid': device.oid});
    //
  }

  Future<void> setObjectCheckinPeriod(int value) async {
    MetricaService.event('device_set_checkin_period', {'oid': device.oid});
    int period = 0;
    if (value == 1) {
      period = 60;
    }
    if (value == 2) {
      period = 600;
    }
    if (value == 3) {
      period = 3600;
    }
    setBusy(true);
    try {
      final ret = await api.setObjectCheckinPeriod(device.oid, period);
      logger.i(ret);
      if (ret == 0) {
        // showAppDialog(title: '', subtitle: 'Запрос отправлен');
      }
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        // проверьте интернет
        final retry = await showAppDialog(
          title: Strings.current.error,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == true) savePhone();
        return;
      }
      switchError(e.error);
    } finally {}
    await devicesService.update(force: true);
    modeController.text = getStringCheckinPeriod(device.deviceProps?.checkinPeriod);
    setBusy(false);
    notifyListeners();
  }

  Future onTrustedTap() async {
    MetricaService.event('device_trusted_tap', {'oid': device.oid});
    final phonebook = await navigator.push(TrustedNumbersViewRoute(device));
    if (phonebook == null) return;
    trustedController.text =
        '${phonebook.length.toString()} ${getStringForNumbersLength(phonebook.length)}';
    notifyListeners();
  }

  Future<void> deleteDevice() async {
    MetricaService.event('device_delete', {'oid': device.oid});
    setBusy(true);
    final ret = await api.deleteDevice(device.deviceProps!.imei!);
    if (ret == null) return setBusy(false);
    await devicesService.update(force: true);
    setBusy(false);
    navigator.popUntil((route) => route.isFirst);
    notifyListeners();
  }

  String getStringForNumbersLength(int length) {
    String text;
    final last = int.parse(length.toString().characters.last);
    if (last == 1) {
      text = 'доверенный номер';
    } else if ([2, 3, 4].any((element) => element == last)) {
      text = 'доверенных номера';
    } else {
      text = 'доверенных номеров';
    }
    return text;
  }

  Future<void> savePhone() async {
    MetricaService.event('device_update_phone', {'oid': device.oid});
    setBusy(true);
    try {
      final ret = await api.changeObjectCard(device.oid, phoneController.text);
      logger.i(ret);
      if (ret == 0) {
        // showAppDialog(title: '', subtitle: 'Запрос отправлен');
      }
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        // проверьте интернет
        final retry = await showAppDialog(
          title: Strings.current.error,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == true) savePhone();
        return;
      }
      switchError(e.error);
    } finally {}
    await devicesService.update(force: true);
    setBusy(false);
  }

  String getStringCheckinPeriod(int? checkinPeriod) {
    String? text = '';
    if (checkinPeriod == 60) {
      text = 'Постоянный режим';
    }
    if (checkinPeriod == 600) {
      text = 'Нормальный режим';
    }
    if (checkinPeriod == 3600) {
      text = 'Экономный режим';
    }
    return text;
  }
}
