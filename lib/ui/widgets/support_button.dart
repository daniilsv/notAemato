import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/data/services/thrid.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'tappable.dart';

class SupportButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tappable(
      onPressed: () {
        onSupportTap(context);
      },
      child: Container(
        decoration: DottedDecoration(dash: const [2, 2]),
        child: Text(
          Strings.current.support_service,
          style: AppStyles.textSecondary,
        ),
      ),
    );
  }

  Future<void> onSupportTap(BuildContext context) async {
    Function onTap(String url, String errWhat) => () async {
          try {
            MetricaService.event('support_tap', {'service': errWhat});
            await launch(url);
            Navigator.pop(context);
          } on dynamic {
            Navigator.pop(context);
            locator<SnackbarService>().showCustomSnackBar(
              variant: SnackbarType.error,
              title: Strings.current.error,
              message: Strings.current.couldnt_open(errWhat),
              duration: const Duration(seconds: 3),
            );
          }
        };

    showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          message: Text(Strings.current.select_preffered_conn),
          actions: [
            CupertinoActionSheetAction(
              onPressed: onTap('viber://pa/info?uri=notaemato', 'Viber') as void Function(),
              child: Text(Strings.current.write_to('Viber')),
            ),
            CupertinoActionSheetAction(
              onPressed: onTap('https://t.me/Notaematobot', 'Telegram') as void Function(),
              child: Text(Strings.current.write_to('Telegram')),
            ),
            CupertinoActionSheetAction(
              onPressed: onTap('https://m.me/Notaemato', 'Facebook') as void Function(),
              child: Text(Strings.current.write_to('Facebook')),
            ),
            CupertinoActionSheetAction(
              onPressed: onTap(
                'https://some.ru/support/#support-form',
                Strings.current.to_mail,
              ) as void Function(),
              child: Text(Strings.current.write_on(Strings.current.to_mail)),
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
}
