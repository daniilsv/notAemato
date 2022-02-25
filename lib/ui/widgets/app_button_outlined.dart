import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notaemato/ui/theme/theme.dart';

class AppButtonOutlined extends StatelessWidget {
  const AppButtonOutlined({
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: const [],
          border: Border.all(color: AppColors.stroke),
          borderRadius: AppBorderRadius.button,
        ),
        child: Padding(
          padding: AppPaddings.all18,
          child: Center(
            child: Text(
              text,
              style: AppStyles.primaryTextButton,
            ),
          ),
        ),
      ),
    );
  }
}
