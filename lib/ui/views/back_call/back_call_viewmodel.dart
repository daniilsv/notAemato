import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/dto/socket_error.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/widgets/app_dialog.dart';
import 'package:notaemato/ui/widgets/switch_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class BackCallViewModel extends BaseViewModel {
  BackCallViewModel(BuildContext context) {
    oid = ModalRoute.of(context)!.settings.arguments as int?;
  }
  // Services
  late final api = locator<SocketApi>();

  // Constants
  int? oid;

  // Controllers
  final phoneController = TextEditingController();

  // Variables

  // Logic

  Future onReady() async {
    //
  }

  Future<bool> onWillPop() async {
    //TODO: check empty devices => show modal
    return true;
  }

  Future<void> onCallTap(BuildContext context) async {
    FocusScope.of(context).unfocus();
    MetricaService.event('back_call', {'oid': oid});
    try {
      final ret = await api.requestObjectMonitorCallback(oid, phoneController.text);
      logger.i(ret);
      if (ret == 0) {
        showAppDialog(
            title: 'Ожидайте звонка с устройства', subtitle: 'Запрос отправлен');
      }
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        // проверьте интернет
        final retry = await showAppDialog(
          title: Strings.current.error,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == true) onCallTap(context);
        return;
      }
      switchError(e.error);
    } finally {}
    notifyListeners();
  }
}
