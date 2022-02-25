import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';

import 'dnd_viewmodel.dart';

class DndsViewRoute extends CupertinoPageRoute {
  DndsViewRoute({DeviceModel? device})
      : super(
            builder: (context) => const DndsView(),
            settings: RouteSettings(arguments: device));
}

class DndsView extends StatelessWidget {
  const DndsView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DndsViewModel>.reactive(
      viewModelBuilder: () => DndsViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
            isBusy: model.isBusy,
            title: 'Не беспокоить',
            body: Padding(
              padding: AppPaddings.h24,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Создайте до 4-х интервалов в течении которых на часы не будут приходит уведомления и отвлекать ребенка от уроков или сна.',
                    textAlign: TextAlign.left,
                    style: AppStyles.caption,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Tappable(
                            onPressed: () => model.onDndTap(model.dnds![index], index),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                      Jiffy('${model.dnds![index].beginHour}:${model.dnds![index].beginMinute}',
                                                  'HH:mm')
                                              .Hm +
                                          '-' +
                                          Jiffy('${model.dnds![index].endHour}:${model.dnds![index].endMinute}',
                                                  'HH:mm')
                                              .Hm,
                                      style: AppStyles.textSemi),
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded,
                                    color: AppColors.lightText, size: 24),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height:24),
                        itemCount: model.dnds?.length ?? 0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: AppButton(
                        text: 'Новый интервал',
                        onPressed: model.supportedDevice() ? model.onAddDndTap : null),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
