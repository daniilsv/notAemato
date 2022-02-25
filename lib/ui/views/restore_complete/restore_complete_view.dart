import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/views/login/login_view.dart';
import 'package:notaemato/ui/widgets/center_bottom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RestoreCompleteView extends StatelessWidget {
  const RestoreCompleteView(this.email);
  final String email;
  @override
  Widget build(BuildContext context) {
    return CenterWithBottomButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(context, LoginViewRoute());
      },
      title: '${Strings.current.check_mail}!',
      text: Strings.current.instructions_sent_to(email),
      buttonTitle: Strings.current.to_sign_in_screen,
      doneIcon: true,
    );
  }
}
