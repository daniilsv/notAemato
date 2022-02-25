import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';

import 'tappable.dart';

class AppButtonIcon extends StatelessWidget {
  const AppButtonIcon(
      {Key? key,
      this.onPressed,
      this.icon = Icons.done,
      this.iconColor = AppColors.white,
      this.bgColor = AppColors.primary})
      : super(key: key);
  final VoidCallback? onPressed;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onPressed: onPressed,
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
