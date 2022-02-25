import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/api/api.dart';
import 'package:notaemato/data/model/dto/restore_request.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/views/restore_complete/restore_complete_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:validators/validators.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  final Api? api = locator<Api>();
  final loginController = TextEditingController();
  bool emailError = false;

  bool get isActive => loginController.text.isNotEmpty;

  void onReady() {
    loginController.addListener(notifyListeners);
  }

  Future<void> restore(BuildContext context) async {
    emailError = !isEmail(loginController.text);
    if (emailError) {
      notifyListeners();
      return;
    }
    try {
      await api!.auth.restore(RestoreRequest(loginController.text));
      MetricaService.event('restored_pass');
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => RestoreCompleteView(loginController.text)),
      );
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(Strings.current.check_email),
            content: Text(Strings.current.no_user_with_this_email),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(Strings.current.okay),
              ),
            ],
          ),
        );
      } else {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(Strings.current.couldnt_send_letter),
            content: Text(Strings.current.check_connection_and_try_again),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  restore(context);
                },
                child: Text(
                  Strings.current.retry,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(Strings.current.cancel),
              ),
            ],
          ),
        );
      }
    } finally {
      setBusy(false);
    }
  }
}
