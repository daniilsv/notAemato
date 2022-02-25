import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_button_outlined.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/app_text_field.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'profile_viewmodel.dart';

class ProfileViewRoute extends CupertinoPageRoute {
  ProfileViewRoute() : super(builder: (context) => const _ProfileView());
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          isBusy: model.isBusy,
          title: model.service.isNewUser ? 'Информация о вас' : 'Ваш аккаунт',
          implyLeading: !model.service.isNewUser,
          onWillPop: model.onWillPop,
          body: ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              Text('Ваше фото', style: AppStyles.textSemi),
              const SizedBox(height: 16),
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
                      else if (model.service.user!.photo?.isNotEmpty ?? false)
                        Align(
                          child: Container(
                            width: 120,
                            height: 120,
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(shape: BoxShape.circle),
                            child: Image.network(
                              model.service.user!.photo!,
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
                        const Positioned(
                          top: 9,
                          right: 9,
                          child: Icon(
                            Icons.cancel,
                            size: 30,
                            color: AppColors.gray90,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Фото необязательно.',
                style: AppStyles.textSecondary,
              ),
              const SizedBox(height: 32),
              Text('Представьтесь', style: AppStyles.textSemi),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Ваше имя',
                controller: model.controller,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: model.service.isNewUser ? 'Продолжить' : 'Сохранить',
                onPressed: model.isValid ? () => model.save(context) : null,
              ),
              const SizedBox(height: 12),
              if (!model.service.isNewUser)
                AppButtonOutlined(
                  text: 'Выйти из приложения',
                  onPressed: () => model.logout(context),
                )
            ],
          ),
        );
      },
    );
  }
}
