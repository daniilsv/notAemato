import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'repeat_viewmodel.dart';

class RepeatAlarmsViewRoute extends CupertinoPageRoute<List<bool>> {
  RepeatAlarmsViewRoute({List<bool>? repeat})
      : super(
          builder: (context) => const RepeatAlarmsView(),
          settings: RouteSettings(arguments: repeat),
        );
}

class RepeatAlarmsView extends StatelessWidget {
  const RepeatAlarmsView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RepeatAlarmsViewModel>.reactive(
      viewModelBuilder: () => RepeatAlarmsViewModel(context),
      builder: (context, model, child) {
        return AppScaffold(
          title: 'Повторять',
          onWillPop: () async => false,
          onPop: model.onPop,
          body: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 24),
            padding: AppPaddings.h24,
            itemCount: model.repeat.length,
            itemBuilder: (context, index) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  model.getDayName(index),
                  style: AppStyles.repeatDay,
                ),
                CupertinoSwitch(
                  value: model.repeat[index],
                  onChanged: (bool value) {
                    model.onChanged(index);
                  },
                  activeColor: AppColors.green,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
