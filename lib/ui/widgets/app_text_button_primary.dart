import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notaemato/ui/theme/theme.dart';

class AppTextButtonPrimary extends StatelessWidget {
  const AppTextButtonPrimary({
    required this.onPressed,
    required this.text,
    Key? key,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      minSize: 0,
      padding: EdgeInsets.zero,
      child: Text(
        text,
        style: AppStyles.primaryTextButton,
      ),
    );
  }
}