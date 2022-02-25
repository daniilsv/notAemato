import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(.4),
      alignment: Alignment.center,
      child: SizedBox(
        width: 64,
        height: 64,
        child: CircularProgressIndicator(
          backgroundColor: AppColors.white.withOpacity(.6),
          valueColor: const AlwaysStoppedAnimation(AppColors.white),
        ),
      ),
    );
  }
}
