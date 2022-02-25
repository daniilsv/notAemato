import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/app_text_field.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'alarm_viewmodel.dart';

class AlarmViewRoute extends CupertinoPageRoute<Map<bool, AlarmClock>> {
  AlarmViewRoute({AlarmClock? alarmClock})
      : super(
            builder: (context) => const AlarmView(),
            settings: RouteSettings(arguments: alarmClock));
}

class AlarmView extends StatelessWidget {
  const AlarmView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AlarmViewModel>.reactive(
      viewModelBuilder: () => AlarmViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          onWillPop: () async => false,
          onPop: model.onPop,
          title: model.initial != null ? 'Редактировать' : 'Новый будильник',
          body: Padding(
            padding: AppPaddings.h24,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Tappable(
                        onPressed: () => model.onTimeTap(context),
                        child: IgnorePointer(
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              AppTextField(
                                label: 'Время',
                                controller: model.timeController,
                              ),
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 16),
                                  child: Icon(Icons.arrow_forward_ios_rounded,
                                      color: AppColors.lightText, size: 24),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Tappable(
                        onPressed: () => model.onRepeatTap(model.alarm.repeat ?? []),
                        child: IgnorePointer(
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              AppTextField(
                                label: 'Повторение',
                                controller: model.repeatController,
                              ),
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 16),
                                  child: Icon(Icons.arrow_forward_ios_rounded,
                                      color: AppColors.lightText, size: 24),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: AppButton(
                      text: model.initial != null
                          ? 'Удалить будильник'
                          : 'Добавить будильник',
                      onPressed: model.onButtonTap,
                      color: model.initial != null ? AppColors.red : null),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
