import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/api/api.dart';
import 'package:notaemato/data/model/dto/register_request.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/views/login/login_view.dart';
import 'package:notaemato/ui/views/register_complete/register_complete_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:validators/validators.dart';

class RegisterViewModel extends BaseViewModel {
  final Api? api = locator<Api>();
  final emailController = TextEditingController();
  bool agreement = false;
  bool news = false;
  bool emailError = false;

  void toggleAgreement() {
    agreement = !agreement;
    notifyListeners();
  }

  void toggleNews() {
    news = !news;
    notifyListeners();
  }

  Future<void> onReady() async {
    emailController.addListener(() {
      if (emailError) {
        emailError = false;
        notifyListeners();
      }
    });
  }

  Future<void> onRegisterTap(BuildContext context) async {
    emailError = !isEmail(emailController.text);
    if (emailError) {
      notifyListeners();
      return;
    }
    setBusy(true);
    try {
      await api!.auth.register(RegisterRequest(
        emailController.text,
        'ru',
        isSubscriber: news,
      ));
      MetricaService.event('signed_up');
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (_) => RegisterCompleteView(email: emailController.text)));
    } on DioError catch (e) {
      if (e.response?.statusCode == 400 &&
          e.response?.data != null &&
          (e.response?.data['code'] == 4003 || e.response?.data['code'] == 4004)) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(Strings.current.email_in_use),
            content: Text(Strings.current.sign_in_if_registered_before),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context)
                    ..pop()
                    ..pop(context)
                    ..push(LoginViewRoute(email: emailController.text));
                },
                child: Text(
                  Strings.current.to_sign_in,
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
      } else {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(Strings.current.couldnt_register),
            content: Text(Strings.current.check_connection_and_try_again),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  onRegisterTap(context);
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
