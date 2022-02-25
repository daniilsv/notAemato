import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/app_text_field.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'settings_viewmodel.dart';

class SettingsViewRoute extends CupertinoPageRoute {
  SettingsViewRoute(DeviceModel device)
      : super(
            builder: (context) => const SettingsView(),
            settings: RouteSettings(arguments: device));
}

class SettingsView extends StatelessWidget {
  const SettingsView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      viewModelBuilder: () => SettingsViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          title: 'Настройки',
          isBusy: model.isBusy,
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: AppPaddings.h24,
                  children: [
                    Tappable(
                      onPressed: model.onTrustedTap,
                      child: IgnorePointer(
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            AppTextField(
                              label: 'Доверенные и SOS номера',
                              controller: model.trustedController,
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
                    AppTextField(
                      label: 'Номер часов',
                      onSubmited: (v) => model.savePhone(),
                      controller: model.phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    Tappable(
                      onPressed: () => model.onModeTap(context),
                      child: IgnorePointer(
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            AppTextField(
                              label: 'Режим трекинга',
                              controller: model.modeController,
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
                      onPressed: model.onTimeZoneTap,
                      child: IgnorePointer(
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            AppTextField(
                              label: 'Часовой пояс',
                              controller: model.timeZoneController,
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
                padding: const EdgeInsets.all(24.0),
                child: AppButton(
                  color: AppColors.red,
                  text: 'Удалить устройство',
                  onPressed: model.deleteDevice,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
