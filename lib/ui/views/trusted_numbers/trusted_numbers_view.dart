import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_button_outlined.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/phone_numbers_tile.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'trusted_numbers_viewmodel.dart';

class TrustedNumbersViewRoute extends CupertinoPageRoute<List<PhonebookPhone>> {
  TrustedNumbersViewRoute(DeviceModel? device)
      : super(
            builder: (context) => const TrustedNumbersView(),
            settings: RouteSettings(arguments: device));
}

class TrustedNumbersView extends StatelessWidget {
  const TrustedNumbersView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TrustedNumbersViewModel>.reactive(
      viewModelBuilder: () => TrustedNumbersViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          title: 'Доверенные номера',
          onWillPop: model.onWillPop,
          onPop: model.onPop,
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
                        'Другие доверенные – номера с которых будет разрешен входящий или исходящий звонок с часов.',
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
                          itemBuilder: (context, index) => Tappable(
                            onPressed: () => model.onPhoneTap(index),
                            child: PhoneNumbersTile(
                              sos: model.getSosNumber(model.phonebook[index].phone),
                              name: model.phonebook[index].name,
                              number: model.phonebook[index].phone,
                              onReject: () => model.onReject(context, index),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                AppButton(
                  text: 'Добавить номер',
                  onPressed: () => model.onAddNumberTap(context),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: AppButtonOutlined(
                    text: 'Настроить SOS-номера',
                    onPressed: model.onSosTap,
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
