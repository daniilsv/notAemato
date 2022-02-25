import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({Key? key, this.value, this.onTap}) : super(key: key);
  final bool? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onPressed: onTap,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: value! ? AppColors.primary : AppColors.white,
            border: Border.all(
              color: value! ? AppColors.primary : AppColors.gray70,
            )),
        alignment: Alignment.center,
        child: value!
            ? const Icon(
                Icons.done,
                color: AppColors.white,
                size: 10,
              )
            : const SizedBox(),
      ),
    );
  }
}
