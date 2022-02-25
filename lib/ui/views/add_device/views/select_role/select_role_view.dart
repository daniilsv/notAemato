import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_radio_list_tile.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/app_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'select_role_view_model.dart';

class SelectRoleViewRoute extends CupertinoPageRoute<String> {
  SelectRoleViewRoute(String role)
      : super(
            builder: (context) => const _SelectRoleView(),
            settings: RouteSettings(arguments: role));
}

class _SelectRoleView extends StatelessWidget {
  const _SelectRoleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectRoleViewModel>.reactive(
      viewModelBuilder: () => SelectRoleViewModel(context),
      builder: (context, model, _) {
        return AppScaffold(
          title: Strings.current.you_role,
          body: ListView(
            padding: AppPaddings.h24,
            children: [
              const SizedBox(height: 32),
              Text(
                Strings.current.enter_you_option,
                textAlign: TextAlign.left,
                style: AppStyles.textSemi,
              ),
              const SizedBox(height: 16),
              //TODO: check this
              AppTextField(
                label: Strings.current.enter_role,
                controller: model.roleController,
              ),
              const SizedBox(height: 16),
              Text(
                Strings.current.choose_from_ready,
                textAlign: TextAlign.left,
                style: AppStyles.textSemi,
              ),
              const SizedBox(height: 16),
              ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  shrinkWrap: true,
                  itemCount: model.roles.length,
                  itemBuilder: (context, index) {
                    return AppRadioListTile(
                      value: model.value(index),
                      text: model.roles[index],
                      onTap: () => model.setRole(index),
                    );
                  }),
              const SizedBox(height: 32),
              AppButton(
                text: Strings.current.done,
                onPressed: model.onDone,
              ),
            ],
          ),
        );
      },
    );
  }
}
