import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button_outlined.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/phone_numbers_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'sos_phones_viewmodel.dart';

class SosPhonesViewRoute extends CupertinoPageRoute {
  SosPhonesViewRoute(DeviceModel? device)
      : super(
          builder: (context) => const SosPhonesView(),
          settings: RouteSettings(arguments: device),
        );
}

class SosPhonesView extends StatelessWidget {
  const SosPhonesView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SosPhonesViewModel>.reactive(
      viewModelBuilder: () => SosPhonesViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          title: 'Настроить SOS-номера',
          // onWillPop: model.onWillPop,
          // onPop: model.onPop,
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
                        'Укажите порядковый номер рядом с каждым номером. Номера будут обзваниваться по заданному порядку.',
                        textAlign: TextAlign.left,
                        style: AppStyles.caption,
                      ),
                      const SizedBox(height: 16),
                      if (model.phonebook.isNotEmpty)
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 16);
                          },
                          shrinkWrap: true,
                          itemCount: model.phonebook.length,
                          itemBuilder: (context, index) => PhoneNumbersTile(
                            sos: model.getSosNumber(model.phonebook[index].phone),
                            name: model.phonebook[index].name,
                            number: model.phonebook[index].phone,
                            onSosSelection: () => model.onSosSelect(
                              context,
                              model.phonebook[index]
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                // AppButtonOutlined(
                //     text: 'delete all Sos',
                //     onPressed: model.deleteSosNumbers,
                //   ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: AppButtonOutlined(
                    text: 'Сохранить',
                    onPressed: model.save,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
