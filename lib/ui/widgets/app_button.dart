import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notaemato/ui/theme/theme.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    this.onPressed,
    this.color,
    Key? key,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      minSize: 0,
      padding: EdgeInsets.zero,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: onPressed == null
              ? AppColors.gray70
              : color ?? AppColors.primary,
          boxShadow: const [],
          borderRadius: AppBorderRadius.button,
        ),
        child: Padding(
          padding: AppPaddings.all18,
          child: Center(
            child: Text(
              text,
              style: AppStyles.whiteTextButton,
            ),
          ),
        ),
      ),
    );
  }
}
