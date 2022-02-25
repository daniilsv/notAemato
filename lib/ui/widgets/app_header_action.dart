import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';

class AppHeaderAction extends StatelessWidget {
  const AppHeaderAction({required this.onTap, required this.icon, this.topPadding, this.right})
      : super();
  final Function onTap;
  final IconData icon;
  final double? topPadding;
  final double? right;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      margin: EdgeInsets.only(
        right: right ?? 16,
        top: topPadding ?? 10,
      ),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.gray10,
      ),
      child: Material(
        child: InkWell(
          onTap: onTap as void Function()?,
          child: Icon(
            icon,
            size: 24,
            color: AppColors.gray100,
          ),
        ),
      ),
    );
  }
}
