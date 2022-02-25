import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/app_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'back_call_viewmodel.dart';

class BackCallViewRoute extends CupertinoPageRoute {
  BackCallViewRoute(int? oid)
      : super(
          builder: (context) => const BackCallView(),
          settings: RouteSettings(arguments: oid),
        );
}

class BackCallView extends StatelessWidget {
  const BackCallView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BackCallViewModel>.reactive(
      viewModelBuilder: () => BackCallViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          isBusy: model.isBusy,
          onWillPop: model.onWillPop,
          title: 'Обратный звонок',
          body: ListView(
            padding: AppPaddings.h24,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Эта функция заставляет часы в тихом режиме звонить на заданный номер и услышать, что происходит вокруг.',
                textAlign: TextAlign.left,
                style: AppStyles.caption,
              ),
              const SizedBox(height: 16),
              const Text(
                'Введите номер на который должны позвонить часы.',
                textAlign: TextAlign.left,
                style: AppStyles.caption,
              ),
              const SizedBox(height: 32),
              AppTextField(
                label: 'Номер',
                controller: model.phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: 'Позвонить',
                onPressed: () => model.onCallTap(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
