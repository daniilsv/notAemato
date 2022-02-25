import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/forgot_password/forgot_password_view_model.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/app_text_field.dart';
import 'package:notaemato/ui/widgets/support_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
      viewModelBuilder: () => ForgotPasswordViewModel(),
      onModelReady: (model) => model.onReady(),
      builder: (_, model, __) {
        return AppScaffold(
          title: 'Восстановление пароля',
          isBusy: model.isBusy,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        Strings.current.enter_email_for_restore,
                        style: AppStyles.text,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      AppTextField(
                        label: Strings.current.e_mail,
                        keyboardType: TextInputType.emailAddress,
                        controller: model.loginController,
                        error: model.emailError ? Strings.current.check_input : null,
                      ),
                      const SizedBox(height: 32),
                      AppButton(
                        onPressed: model.isActive ? () => model.restore(context) : null,
                        text: Strings.current.restore_password,
                      )
                    ],
                  ),
                ),
              ),
              SupportButton(),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
