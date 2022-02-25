import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/app_text_field.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'dnd_viewmodel.dart';

class DndViewRoute extends CupertinoPageRoute<Map<bool, DndMode>> {
  DndViewRoute({DndMode? dnd})
      : super(
            builder: (context) => const DndView(),
            settings: RouteSettings(arguments: dnd));
}

class DndView extends StatelessWidget {
  const DndView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DndViewModel>.reactive(
      viewModelBuilder: () => DndViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          onWillPop: () async => false,
          onPop: model.onPop,
          title: model.initial != null ? 'Редактировать' : 'Новый интервал',
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
                                label: 'Интервал',
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: AppButton(
                      text: model.initial != null
                          ? 'Удалить интервал'
                          : 'Добавить интервал',
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
