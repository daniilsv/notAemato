import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/services/navigator.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/widgets/center_bottom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPersonCompleteView extends StatelessWidget {
  const AddPersonCompleteView({
    required this.name,
    Key? key,
  }) : super(key: key);
  final String? name;

  @override
  Widget build(BuildContext context) {
    return CenterWithBottomButton(
      onPressed: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
        locator<NavigatorService>().changePage(0);
        locator<NavigatorService>()
            .navigatorKeys[0]
            .currentState!
            .popUntil((route) => route.isFirst);
      },
      title: '${Strings.current.done}!',
      text: 'Устройство для персоны $name добавлено',
      buttonTitle: 'Перейти на дашборд',
      doneIcon: true,
    );
  }
}
