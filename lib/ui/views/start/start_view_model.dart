import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/repository/user.dart';
import 'package:notaemato/data/services/intl.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/views/login/login_view.dart';
import 'package:notaemato/ui/views/register/register_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class StartViewModel extends BaseViewModel {
  int tapNumber = 0;

  Future<void> onRegisterTap(BuildContext context) async {
    MetricaService.event('to_signup');
    Navigator.push(context, RegisterViewRoute());
  }

  Future<void> onLoginTap(BuildContext context) async {
    MetricaService.event('to_signin');
    Navigator.push(context, LoginViewRoute());
  }

  Future<void> onChangeLangTap(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          message: Text(Strings.current.select_app_lang),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                MetricaService.event('change_lang', {'lang': 'en'});
                locator<IntlService>().locale = 'en';
                Navigator.pop(context);
              },
              child: Text(Strings.current.english),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                MetricaService.event('change_lang', {'lang': 'ru'});
                locator<IntlService>().locale = 'ru';
                Navigator.pop(context);
              },
              child: Text(Strings.current.russian),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              Strings.current.cancel,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }

  Future<void> onImageTap(BuildContext context) async {
    ++tapNumber;
    if (tapNumber < 10) return;

    final stage = await showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          message: Text(Strings.current.select_server),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, 'prod');
              },
              child: const Text('Prod'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, 'stage');
              },
              child: const Text('Stage'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context, 'test');
              },
              child: const Text('Test'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              Strings.current.cancel,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
    tapNumber = 0;
    if (stage == null) return;
    final repo = locator<UserRepository>();
    repo.stage.val = stage;
  }
}
