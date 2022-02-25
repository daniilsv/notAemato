import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/app_text_field.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'add_number_viewmodel.dart';

class AddNumberViewRoute extends CupertinoPageRoute<PhonebookPhone> {
  AddNumberViewRoute() : super(builder: (context) => const AddNumberView());
}

class AddNumberView extends StatelessWidget {
  const AddNumberView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddNumberViewModel>.reactive(
      viewModelBuilder: () => AddNumberViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  color: AppColors.bg,
                  height: 73,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: AppTextField(
                          controller: model.textController,
                          hintText: 'Введите имя или номер',
                          onChanged: (text) {
                            model.onChangedSearch(text);
                          },
                        )),
                        Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.only(left: 16),
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.gray10,
                          ),
                          child: Material(
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: AppColors.gray100,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (model.isBusy)
                  const Center(child: CircularProgressIndicator())
                else if (model.viewContacts.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      controller: model.scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: model.viewContacts.length,
                      itemBuilder: (context, index) {
                        final Contact contact = model.getContact(index);
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(contact.displayName!),
                          subtitle: Text(contact.phones!.first.value ?? ''),
                          onTap: () => model.onContactTap(contact),
                        );
                      },
                    ),
                  )
                else if (model.validNumber)
                  Center(
                    child: TextButton(
                      onPressed: model.onAddContactTap,
                      child: Text('Добавить номер ${model.clearNumber}'),
                    ),
                  )
                else
                  const Center(
                    child: Text('Не найдено номеров по запросу'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
