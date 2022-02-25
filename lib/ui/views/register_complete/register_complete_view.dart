import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/views/login/login_view.dart';
import 'package:notaemato/ui/widgets/center_bottom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterCompleteView extends StatelessWidget {
  const RegisterCompleteView({
    required this.email,
    Key? key,
  }) : super(key: key);
  final String email;

  @override
  Widget build(BuildContext context) {
    return CenterWithBottomButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(context, LoginViewRoute(email: email));
        },
        title: '${Strings.current.done}!',
        text: Strings.current.to_finish_register_bla_bla_bla,
        buttonTitle: Strings.current.to_sign_in_screen,
        doneIcon: true);
  }
}
