import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/person.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_card.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/device_card_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import 'shift_devices_viewmodel.dart';

class ShiftDevicesViewRoute extends CupertinoPageRoute {
  ShiftDevicesViewRoute(Map<PersonModel, DeviceModel?> shiftDevices)
      : super(
            builder: (context) => const ShiftDevicesView(),
            settings: RouteSettings(arguments: shiftDevices));
}

class ShiftDevicesView extends StatelessWidget {
  const ShiftDevicesView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShiftDevicesViewModel>.reactive(
        viewModelBuilder: () => ShiftDevicesViewModel(context),
        onModelReady: (model) => model.onReady(),
        builder: (context, model, child) {
          return AppScaffold(
              title: 'Замена устройства',
              isBusy: model.isBusy,
              body: Padding(
                padding: AppPaddings.h24,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            'Для пользователя ${model.shiftDevices!.keys.first.name} уже назначено основное устройство. Хотите заменить?',
                            textAlign: TextAlign.left,
                            style: AppStyles.textSemi,
                          ),
                          const SizedBox(height: 42),
                          AppCard(
                              child: DeviceTile(device: model.shiftDevices!.values.first)),
                          const SizedBox(height: 24),
                          Center(
                            child: SvgPicture.asset(
                              AppIcons.down,
                              width: 38,
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppCard(
                              child: DeviceTile(device: model.shiftDevices!.values.last)),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: AppButton(
                        text: 'Заменить и продолжить',
                        onPressed: model.save,
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
