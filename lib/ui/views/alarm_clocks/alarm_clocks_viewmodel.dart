import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/dto/socket_error.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/widgets/app_dialog.dart';
import 'package:notaemato/ui/widgets/switch_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import 'views/alarm_view.dart';

class AlarmClocksViewModel extends ReactiveViewModel {
  AlarmClocksViewModel(this.context) {
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

  // Controllers

  // Variables
  List<AlarmClock>? alarms = [];
  late DeviceModel initial;
  DeviceModel get device =>
      devicesService.devices.val!.firstWhere((element) => element == initial);
  BuildContext context;

  // Logic

  Future onReady() async {
    alarms = device.deviceProps!.alarmClock;
  }

  void onChanged(int index) {
    alarms![index].enabled = !alarms![index].enabled!;
    setObjectAlarmClock();
    notifyListeners();
  }

  Future onAddAlarmTap() async {
    final ret = await navigator.push(AlarmViewRoute());
    if (ret != null) {
      if (ret.keys.first) alarms!.add(ret.values.first);
      await setObjectAlarmClock();
    }
    notifyListeners();
  }

  Future<void> onAlarmTap(AlarmClock alarm, int index) async {
    final ret = await navigator.push(AlarmViewRoute(alarmClock: alarm));
    if (ret != null) {
      if (ret.keys.first) alarms![index] = ret.values.first;
      if (!ret.keys.first) alarms!.removeAt(index);
      await setObjectAlarmClock();
    }
    notifyListeners();
  }

  String getRepeatString(List<bool> repeat) {
    final List<String> string = [];
    if (repeat[0]) string.add('Пн');
    if (repeat[1]) string.add('Вт');
    if (repeat[2]) string.add('Ср');
    if (repeat[3]) string.add('Чт');
    if (repeat[4]) string.add('Пт');
    if (repeat[5]) string.add('Сб');
    if (repeat[6]) string.add('Вс');
    if (string.length == 7)
      string
        ..clear()
        ..add('Каждый день');
    if (string.isEmpty) string.add('Не повторять');
    return string.join(', ');
  }

  bool supportedDevice() {
    if (device.family == 'G36' && alarms!.length >= 3) return false;
    if (device.family == 'KSW' && alarms!.isNotEmpty) return false;
    return true;
  }

  Future<void> setObjectAlarmClock() async {
    setBusy(true);
    try {
      final ret = await api.setObjectAlarmClock(device.oid, alarms);
      logger.i(ret);
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        // проверьте интернет
        final retry = await showAppDialog(
          title: Strings.current.error,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == true) setObjectAlarmClock();
        return;
      }

      switchError(e.error);
    } finally {
      await devicesService.update(force: true);
      onReady();
      setBusy(false);
    }
  }
}
