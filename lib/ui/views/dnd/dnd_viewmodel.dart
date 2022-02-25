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

import 'views/dnd_view.dart';

class DndsViewModel extends ReactiveViewModel {
  DndsViewModel(this.context) {
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
  List<DndMode>? dnds = [];
  late DeviceModel initial;
  DeviceModel get device =>
      devicesService.devices.val!.firstWhere((element) => element == initial);
  BuildContext context;

  // Logic

  Future onReady() async {
    dnds = device.deviceProps!.dndMode;
  }

  Future onAddDndTap() async {
    final ret = await navigator.push(DndViewRoute());
    if (ret != null) {
      if (ret.keys.first) dnds!.add(ret.values.first);
      await setObjectDndMode();
    }
    notifyListeners();
  }

  Future<void> onDndTap(DndMode dnd, int index) async {
    final ret = await navigator.push(DndViewRoute(dnd: dnd));
    if (ret != null) {
      if (ret.keys.first) dnds![index] = ret.values.first;
      if (!ret.keys.first) dnds!.removeAt(index);
      await setObjectDndMode();
    }
    notifyListeners();
  }

  bool supportedDevice() {
    if (dnds!.length >= 4) return false;
    return true;
  }

  Future<void> setObjectDndMode() async {
    setBusy(true);
    try {
      final ret = await api.setObjectDndMode(device.oid, dnds);
      logger.i(ret);
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        // проверьте интернет
        final retry = await showAppDialog(
          title: Strings.current.error,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == true) setObjectDndMode();
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
