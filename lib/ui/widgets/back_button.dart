import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({Key? key, this.icon}) : super(key: key);
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: 36,
        width: 36,
        decoration: const BoxDecoration(
          color: AppColors.gray10,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: icon ??
            const Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.gray100,
              size: 14,
            ),
      ),
    );
  }
}
