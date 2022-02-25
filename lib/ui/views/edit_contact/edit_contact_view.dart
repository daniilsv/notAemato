import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/app_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'edit_contact_viewmodel.dart';

class EditContactViewRoute extends CupertinoPageRoute<PhonebookPhone> {
  EditContactViewRoute(PhonebookPhone? contact)
      : super(
          builder: (context) => const EditContactView(),
          settings: RouteSettings(arguments: contact),
        );
}

class EditContactView extends StatelessWidget {
  const EditContactView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditContactViewModel>.reactive(
      viewModelBuilder: () => EditContactViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
            title: model.contact!.name != null ? 'Изменить контакт' : 'Добавить контакт',
            body: Column(
              children: [
                Expanded(
                  child: ListView(shrinkWrap: true, padding: AppPaddings.h24, children: [
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Отображать контакт на часах как...',
                      controller: model.nameController,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Номер',
                      controller: model.phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AppButton(
                      onPressed: model.isActive ? model.onSaveTap : null,
                      text: model.contact!.name != null ? 'Сохранить номер' : 'Добавить номер'),
                )
              ],
            ));
      },
    );
  }
}
