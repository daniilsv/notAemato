import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_checkbox.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRadioListTile extends StatelessWidget {
  const AppRadioListTile({Key? key, this.value, this.onTap, this.text})
      : super(key: key);
  final VoidCallback? onTap;
  final bool? value;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onPressed: onTap,
      child: Row(
        children: <Widget>[
          AppCheckbox(value: value),
          const SizedBox(width: 16),
          Text(
            text!,
            style: AppStyles.textCheckbox
            ),
          
        ],
      ),
    );
  }
}
