import 'package:notaemato/data/model/person.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/app_text_field.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'person_viewmodel.dart';

class PersonViewRoute extends CupertinoPageRoute<PersonModel> {
  PersonViewRoute({PersonModel? person})
      : super(
          builder: (context) => const PersonView(),
          settings: RouteSettings(arguments: person),
        );
}

class PersonView extends StatelessWidget {
  const PersonView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PersonViewModel>.reactive(
      viewModelBuilder: () => PersonViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          isBusy: model.isBusy,
          title: model.initial != null ? 'Редактирование персоны' : 'Новая персона',
          body: ListView(
            padding: AppPaddings.h24,
            children: [
              const SizedBox(height: 24),
              Tappable(
                onPressed: () => model.pickPhoto(context),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: DottedDecoration(
                    shape: Shape.box,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      if (model.localPhoto != null)
                        Align(
                          child: Container(
                            width: 120,
                            height: 120,
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(shape: BoxShape.circle),
                            child: Image.file(
                              model.localPhoto!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else if (model.initial?.photoUrl?.isNotEmpty ?? false)
                        Align(
                          child: Container(
                            width: 120,
                            height: 120,
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(shape: BoxShape.circle),
                            child: Image.network(
                              model.initial!.photoUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        const Align(
                          child: Icon(
                            Icons.photo_camera,
                            size: 40,
                            color: AppColors.gray90,
                          ),
                        ),
                      if (model.localPhoto != null)
                        Positioned(
                          top: 9,
                          right: 9,
                          child: Tappable(
                            onPressed: model.removePhoto,
                            child: const Icon(
                              Icons.cancel,
                              size: 30,
                              color: AppColors.gray90,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Основная информация',
                textAlign: TextAlign.left,
                style: AppStyles.textSemi,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Имя',
                controller: model.nameController,
              ),
              const SizedBox(height: 16),
              Tappable(
                onPressed: () => model.datePicker(context),
                child: IgnorePointer(
                  child: AppTextField(
                    label: 'Дата рождения',
                    controller: model.dateController,
                    keyboardType: TextInputType.datetime,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Для фитнес-трекера',
                textAlign: TextAlign.left,
                style: AppStyles.textSemi,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Рост (см)',
                controller: model.heightController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Вес (кг)',
                controller: model.weightController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: model.initial != null ? 'Соханить персону' : 'Создать персону',
                onPressed: model.isActive ? () => model.save(context) : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
