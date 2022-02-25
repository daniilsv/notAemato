import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/services/intl.dart';
import 'package:notaemato/env.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/sized_app.dart';
import 'package:notaemato/ui/views/root/root_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stacked_services/stacked_services.dart';

final appBuilderKey = GlobalKey<_AppBuilderState>();
const Size size = Size(320, 534);

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedApp(
      size: size,
      ratio: 1.5,
      overrided: kDebugMode && Env.deviceTestModeEnabled,
      child: AppBuilder(
        key: appBuilderKey,
        builder: (context) => CupertinoApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: StackedService.navigatorKey,
          supportedLocales: Strings.delegate.supportedLocales,
          locale: locator<IntlService>().fullLocale,
          localizationsDelegates: const [
            Strings.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (ctx, child) {
            if (!kDebugMode || !Env.deviceTestModeEnabled) return child!;

            return MediaQuery(
              data: const MediaQueryData(
                size: size,
                devicePixelRatio: 1.5,
              ),
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: child,
              ),
            );
          },
          home: RootView(),
        ),
      ),
    );
  }
}

class AppBuilder extends StatefulWidget {
  const AppBuilder({Key? key, this.builder}) : super(key: key);

  final WidgetBuilder? builder;

  @override
  _AppBuilderState createState() => _AppBuilderState();

  static void rebuild(BuildContext context) {
    context.findAncestorStateOfType<_AppBuilderState>()!.rebuild();
  }
}

class _AppBuilderState extends State<AppBuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.builder!(context);
  }

  void rebuild() {
    setState(() {});
  }
}
