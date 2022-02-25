import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_button_outlined.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/app_text_field.dart';
import 'package:notaemato/ui/widgets/support_button.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import 'add_device_viewmodel.dart';

class AddDeviceViewRoute extends CupertinoPageRoute {
  AddDeviceViewRoute() : super(builder: (context) => const AddDeviceView());
}

class AddDeviceView extends StatelessWidget {
  const AddDeviceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddDeviceViewModel>.reactive(
      viewModelBuilder: () => AddDeviceViewModel(context),
      builder: (context, model, _) {
        return AppScaffold(
          title: Strings.current.add_device_title_line1,
          leadingRight: !model.service.isNewUser,
          onWillPop: model.onWillPop,
          isBusy: model.isBusy,
          body: ListView(
            padding: AppPaddings.h24,
            children: [
              const SizedBox(height: 32),
              Text(
                Strings.current.add_device_code_title,
                textAlign: TextAlign.left,
                style: AppStyles.textSemi,
              ),
              const SizedBox(height: 16),
              AppTextField(
                keyboardType: TextInputType.number,
                label: Strings.current.add_device_code_label,
                controller: model.codeController,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Tappable(
                    color: AppColors.primaryText,
                    onPressed: model.onScanCodeTap,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.qrCode,
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(Strings.current.scan_qr),
                      ],
                    ),
                  ),
                  Tappable(
                    color: AppColors.primaryText,
                    onPressed: model.onWhereCodeTap,
                    child: Text(Strings.current.where_code),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                Strings.current.you_role,
                textAlign: TextAlign.left,
                style: AppStyles.textSemi,
              ),
              const SizedBox(height: 16),
              Tappable(
                onPressed: model.onSelectRoleTap,
                child: IgnorePointer(
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      AppTextField(
                        label: Strings.current.choose_role,
                        controller: model.roleController,
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
              const SizedBox(height: 12),
              Text(
                Strings.current.add_device_role_description,
                style: AppStyles.caption,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: Strings.current.continue_button,
                onPressed: model.isActive ? () => model.save(context) : null,
              ),
              const SizedBox(height: 16),
              Center(child: SupportButton()),
              const SizedBox(height: 16),
              // TODO Delete
              AppButtonOutlined(
                text: 'mock adding',
                onPressed: () => model.mockAdding(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
