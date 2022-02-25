import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_button_dashed.dart';
import 'package:notaemato/ui/widgets/app_card.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/app_text_field.dart';
import 'package:notaemato/ui/widgets/device_card_tile.dart';
import 'package:notaemato/ui/widgets/person_tile.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'person_selection_viewmodel.dart';

class PersonSelectionViewRoute extends CupertinoPageRoute<DeviceModel> {
  PersonSelectionViewRoute([DeviceModel? device])
      : super(
          builder: (context) => const PersonSelectionView(),
          settings: RouteSettings(arguments: device),
        );
}

class PersonSelectionView extends StatelessWidget {
  const PersonSelectionView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PersonSelectionViewModel>.reactive(
      viewModelBuilder: () => PersonSelectionViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          bg: AppColors.gray10,
          isBusy: model.isBusy,
          implyLeading: false,
          // onWillPop: model.onWillPop,
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  color: AppColors.gray10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: AppPaddings.v24h16,
                        child: Text('Почти готово...', style: AppStyles.h1),
                      ),
                      Padding(
                        padding: AppPaddings.h24,
                        child: AppCard(
                          child: DeviceTile(
                            device: model.device,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24)
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: AppPaddings.h24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Кто будет носить часы?',
                        textAlign: TextAlign.left,
                        style: AppStyles.textSemi,
                      ),
                      const SizedBox(height: 16),
                      if (model.persons.isNotEmpty)
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: model.persons.length,
                            itemBuilder: (context, index) {
                              final person = model.persons[index];
                              final DeviceModel? device =
                                  model.getPersonDevice(person.personId);
                              return PersonTile(
                                onTap: () => model.setPerson(index),
                                onAccept: () => model.setPerson(index),
                                title: person.name,
                                photoUrl:
                                    person.photoUrl!.isEmpty ? null : person.photoUrl,
                                value: index == model.selectedPerson,
                                subtitle: device != null
                                    ? 'Часы ${device.type}'
                                    : 'Нет устройства',
                              );
                            }),
                      const SizedBox(height: 16),
                      AppButtonDashed(
                          onPressed: model.onAddPersonTap, text: 'Добавить персону'),
                      if (model.persons.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            Text(
                              'Доверенные номера',
                              textAlign: TextAlign.left,
                              style: AppStyles.textSemi,
                            ),
                            const SizedBox(height: 16),
                            Tappable(
                              onPressed: model.onTrustedNumbersTap,
                              child: IgnorePointer(
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    AppTextField(
                                      isButton: true,
                                      controller: model.trustedNumbersController,
                                    ),
                                    const Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 16),
                                        child: Icon(Icons.arrow_forward_ios_rounded,
                                            color: AppColors.primary, size: 24),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              'Мобильный номер часов',
                              textAlign: TextAlign.left,
                              style: AppStyles.textSemi,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              label: 'Мобильный номер часов',
                              controller: model.phoneController,
                            ),
                          ],
                        ),
                      const SizedBox(height: 32),
                      AppButton(
                        text: Strings.current.done,
                        onPressed: model.persons.isNotEmpty ? model.save : null,
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
