import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/app.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class IntlService {
  IntlService() {
    load();
    _locale.listen((v) => load());
  }

  final _locale = ''.val('_locale', defVal: '');
  set locale(String code) => _locale.val = code;
  String get locale => _locale.val!;

  Locale get fullLocale => Locale.fromSubtags(languageCode: _locale.val!);

  Future<void> load() async {
    if (locale.isEmpty) {
      locale = 'ru';
      return;
    }
    await Strings.load(Locale.fromSubtags(languageCode: locale));
    appBuilderKey.currentState?.rebuild();
  }
}
