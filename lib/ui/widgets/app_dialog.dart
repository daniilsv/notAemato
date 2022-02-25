import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked_services/stacked_services.dart';

Future<T?> showAppDialog<T>({
  String? title,
  String? subtitle,
  String? actionTitle,
  Function? action,
  NavigatorState? navigator,
}) {
  return (navigator ?? StackedService.navigatorKey!.currentState)!.push<T>(
    RawDialogRoute<T>(
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final navigator = Navigator.of(context);
        return CupertinoAlertDialog(
          title: Text(title ?? Strings.current.error),
          content: Text(subtitle ?? Strings.current.check_connection_and_try_again),
          actions: [
            if (actionTitle != null)
              CupertinoDialogAction(
                onPressed: () {
                  navigator.pop(actionTitle); // != null
                  if (action != null) action();
                },
                child: Text(
                  actionTitle, // ?? Strings.current.retry
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            CupertinoDialogAction(
              onPressed: () {
                navigator.pop(null);
                if (action != null && actionTitle == null) action();
              },
              child: Text(
                  actionTitle == null ? Strings.current.okay : Strings.current.cancel,
                  style: actionTitle == null
                      ? const TextStyle(fontWeight: FontWeight.w600)
                      : null),
            ),
          ],
        );
      },
    ),
  );
}
