import 'dart:math';

import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/register/register_view_model.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_checkbox.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/app_text_field.dart';
import 'package:notaemato/ui/widgets/support_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterViewRoute extends CupertinoPageRoute {
  RegisterViewRoute() : super(builder: (context) => _RegisterView());
}

class _RegisterView extends StatelessWidget {
  final border = OutlineInputBorder(
      borderRadius: AppBorderRadius.textField,
      borderSide: const BorderSide(
        width: 1.5,
        color: AppColors.primary,
      ));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ViewModelBuilder<RegisterViewModel>.reactive(
      viewModelBuilder: () => RegisterViewModel(),
      onModelReady: (model) => model.onReady(),
      builder: (_, model, __) {
        return AppScaffold(
          title: Strings.current.register_by_email,
          isBusy: model.isBusy,
          leadingRight: true,
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(height: min(size.height * 0.08, 52)),
                      AppTextField(
                        label: Strings.current.e_mail,
                        keyboardType: TextInputType.emailAddress,
                        controller: model.emailController,
                        error: model.emailError ? Strings.current.check_input : null,
                      ),
                      SizedBox(height: min(size.height * 0.037, 24)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppCheckbox(
                            value: model.agreement,
                            onTap: model.toggleAgreement,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: Strings.current.i_agree),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(
                                          Strings.current.user_agreement_url,
                                        );
                                      },
                                    text: Strings.current.user_agreement,
                                    style: AppStyles.textLinkCheckbox,
                                  ),
                                  TextSpan(
                                    text: Strings.current.and_grant_agreement_bla_bla_bla,
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(
                                          Strings.current.privacy_policy_url,
                                        );
                                      },
                                    text: '${Strings.current.about_privacy_policy}.',
                                    style: AppStyles.textLinkCheckbox,
                                  ),
                                ],
                                style: AppStyles.textCheckbox,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppCheckbox(
                            value: model.news,
                            onTap: model.toggleNews,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              Strings.current.i_want_to_receive_spam,
                              style: AppStyles.textCheckbox,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: min(size.height * 0.0495, 32)),
                      AppButton(
                        onPressed:
                            model.agreement ? () => model.onRegisterTap(context) : null,
                        text: Strings.current.create_account,
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
