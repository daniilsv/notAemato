import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({required this.title, required this.icon, this.onTap, this.padding});

  final IconData icon;
  final String title;
  final Function? onTap;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onPressed: onTap as void Function()?,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.gray90,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppStyles.iconButton,
            )
          ],
        ),
      ),
    );
  }
}
