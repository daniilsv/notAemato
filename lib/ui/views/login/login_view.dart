import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/forgot_password/forgot_password_view.dart';
import 'package:notaemato/ui/views/login/login_view_model.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_button_outlined.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/app_text_field.dart';
import 'package:notaemato/ui/widgets/support_button.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoginViewRoute extends CupertinoPageRoute {
  LoginViewRoute({email})
      : super(
            builder: (context) => LoginView(
                  email: email,
                ));
}

class LoginView extends StatelessWidget {
  const LoginView({Key? key, this.email}) : super(key: key);
  final String? email;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onModelReady: (model) => model.onReady(login: email),
      builder: (context, model, child) {
        return AppScaffold(
          title: Strings.current.sign_in,
          isBusy: model.isBusy,
          body: Column(
            children: [
              const Spacer(),
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppTextField(
                      label: Strings.current.e_mail,
                      keyboardType: TextInputType.emailAddress,
                      controller: model.loginController,
                      error: model.emailError ? Strings.current.check_input : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: Strings.current.password,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      controller: model.passwordController,
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      onPressed: model.isActive ? () => model.login(context) : null,
                      text: Strings.current.to_sign_in,
                    ),
                    const SizedBox(height: 24),
                    Tappable(
                      onPressed: () {
                        MetricaService.event('to_forget');
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (ctx) => ForgotPasswordView(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: DottedDecoration(dash: const [2, 2]),
                        child: Text(
                          Strings.current.forgot_password,
                          style: AppStyles.textSecondary,
                        ),
                      ),
                    ),
                    AppButtonOutlined(onPressed: model.fillMock, text: 'fill mock'),
                  ],
                ),
              ),
              const Spacer(),
              SupportButton(),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
