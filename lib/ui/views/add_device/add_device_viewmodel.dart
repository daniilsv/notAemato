import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/dto/socket_error.dart';
import 'package:notaemato/data/services/auth.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/views/add_device/views/qr_code_scanner.dart';
import 'package:notaemato/ui/views/person_selection/person_selection_view.dart';
import 'package:notaemato/ui/widgets/app_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import 'views/request_device_done.dart';
import 'views/select_role/select_role_view.dart';

class AddDeviceViewModel extends BaseViewModel {
  AddDeviceViewModel(BuildContext context) {
    navigator = Navigator.of(context);
    rootNavigator = Navigator.of(context, rootNavigator: true);
  }
  // Services
  late NavigatorState navigator;
  late NavigatorState rootNavigator;
  final AuthService service = locator<AuthService>();
  final SocketApi api = locator<SocketApi>();

  // Constants

  // Controllers
  final codeController = TextEditingController();
  final roleController = TextEditingController();

  // Variables
  bool get isActive => codeController.text.isNotEmpty && roleController.text.isNotEmpty;

  // Logic

  Future onReady() async {
    codeController.addListener(notifyListeners);
  }

  Future<void> save(BuildContext context) async {
    FocusScope.of(context).unfocus();
    setBusy(true);
    MetricaService.event('add_device', {
      'code': codeController.text,
      'role': roleController.text,
    });
    try {
      final ret = await api.addDevice(codeController.text, roleController.text);
      logger.i(ret);
      navigator.push(PersonSelectionViewRoute(ret));
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        // проверьте интернет
        final retry = await showAppDialog(
          title: Strings.current.device_not_added,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == true) save(context);
        return;
      }
      switch (e.error) {
        case 8005: // проверьте код
          showAppDialog(
            title: Strings.current.check_code,
            subtitle: Strings.current.no_code_in_base,
          );
          break;
        case 4004: // Запросить доступ
          requestAccess();
          break;
        case 4007: // проверьте код
          showAppDialog(
            title: 'Устройство уже добавлено',
            subtitle: 'и привязано к вашему аккаунту',
          );
          break;
      }
    } finally {
      setBusy(false);
    }
  }

  Future<void> requestAccess() async {
    final requestAccess = await showAppDialog<String>(
      title: Strings.current.device_alrady_added,
      subtitle: Strings.current.device_added_another_user,
      actionTitle: Strings.current.request_access,
    );
    if (requestAccess == null) return;
    MetricaService.event('request_access', {
      'code': codeController.text,
      'role': roleController.text,
    });
    try {
      await api.requestDeviceAccess(codeController.text, roleController.text);
      navigator.pushReplacement(RequestDeviceDoneRoute());
    } on SocketError catch (e) {
      if (e.error == 5100) {
        showAppDialog<bool>(
          title: 'Вы уже запросили доступ к этому устройству',
          subtitle: 'Свяжитесь с владельцем для подтверждения',
          action: () => navigator.popUntil((route) => route.isFirst),
        );
      }
    }
  }

  Future<bool> onWillPop() async {
    //TODO: check empty devices => show modal
    return true;
  }

  void onWhereCodeTap() {
    //TODO: show modal/page/watever
  }

  Future<void> onScanCodeTap() async {
    MetricaService.event('add_device_scan_qr');
    final ret = await rootNavigator.push(QRCodeScannerViewRoute());
    if (ret == null) return;
    codeController.text = ret;
    notifyListeners();
  }

  Future<void> onSelectRoleTap() async {
    final ret = await navigator.push(SelectRoleViewRoute(roleController.text));
    if (ret == null) return;
    roleController.text = ret;
    notifyListeners();
  }

  Future<void> mockAdding(BuildContext context) async {
    codeController.text = '964911108701563';
    notifyListeners();
  }
}
