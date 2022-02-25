import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';

import 'alarm_clocks_viewmodel.dart';

class AlarmClocksViewRoute extends CupertinoPageRoute {
  AlarmClocksViewRoute({DeviceModel? device})
      : super(
            builder: (context) => const AlarmClocksView(),
            settings: RouteSettings(arguments: device));
}

class AlarmClocksView extends StatelessWidget {
  const AlarmClocksView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AlarmClocksViewModel>.reactive(
      viewModelBuilder: () => AlarmClocksViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
            isBusy: model.isBusy,
            title: 'Будильники',
            body: Padding(
              padding: AppPaddings.h24,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Tappable(
                                  onPressed: () =>
                                      model.onAlarmTap(model.alarms![index], index),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          Jiffy('${model.alarms![index].hours}:${model.alarms![index].minutes}',
                                                  'HH:mm')
                                              .Hm,
                                          style: AppStyles.textSemi),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              model.getRepeatString(
                                                  model.alarms![index].repeat!),
                                              style: AppStyles.caption),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              CupertinoSwitch(
                                value: model.alarms![index].enabled!,
                                onChanged: (bool value) {
                                  model.onChanged(index);
                                },
                                activeColor: AppColors.green,
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemCount: model.alarms?.length ?? 0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: AppButton(
                        text: 'Новый будильник',
                        onPressed: model.supportedDevice() ? model.onAddAlarmTap : null),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
