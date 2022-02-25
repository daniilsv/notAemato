import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/model/dto/auth_credentials.dart';
import 'package:notaemato/data/model/dto/socket_error.dart';
import 'package:notaemato/data/services/auth.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:validators/validators.dart';

class LoginViewModel extends BaseViewModel {
  final AuthService service = locator<AuthService>();
  late TextEditingController loginController;
  final passwordController = TextEditingController();
  bool emailError = false;

  bool get isActive =>
      loginController.text.isNotEmpty && passwordController.text.isNotEmpty;

  void onReady({String? login}) {
    loginController = TextEditingController(text: login);
    loginController.addListener(notifyListeners);
    passwordController.addListener(notifyListeners);
  }

  Future<void> login(BuildContext context) async {
    emailError = !isEmail(loginController.text);
    if (emailError) {
      notifyListeners();
      return;
    }
    setBusy(true);
    try {
      await service.signIn(AuthCredentials(
        email: loginController.text,
        password: passwordController.text,
      ));
      MetricaService.event('signed_in');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on SocketError catch (e) {
      logger.e(e);
      if (e.error == 9002) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(Strings.current.couldnt_login),
            content: Text(Strings.current.wrong_pair_login_password_try_again),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(Strings.current.ok),
              ),
            ],
          ),
        );
      } else {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(Strings.current.couldnt_login),
            content: Text(Strings.current.check_connection_and_try_again),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  login(context);
                },
                child: Text(
                  Strings.current.retry,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(Strings.current.ok),
              ),
            ],
          ),
        );
      }
    } finally {
      setBusy(false);
    }
  }

  final variants = <List<String>>[
    ['danstrrr@yandex.ru', 'vGThaU'],
    ['daniilsv@itis.team', 'PGevc9'],
    ['dk1001@yandex.ru', 'ss0d5U'],
    ['admin@company.com', 'admin2admin'],
  ];
  int curVariantIndex = -1;
  void fillMock() {
    ++curVariantIndex;
    if (curVariantIndex >= variants.length) curVariantIndex = 0;
    final variant = variants[curVariantIndex];
    loginController.text = variant[0];
    passwordController.text = variant[1];
  }
}
