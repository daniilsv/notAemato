import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';

import 'app_button.dart';

class CenterWithBottomButton extends StatelessWidget {
  const CenterWithBottomButton({
    required this.onPressed,
    required this.title,
    required this.text,
    required this.buttonTitle,
    this.doneIcon,
    Key? key,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String title;
  final String text;
  final String buttonTitle;
  final bool? doneIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.white,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (doneIcon != null)
                          Container(
                            height: 96,
                            width: 96,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: AppColors.green),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.done,
                              size: 36,
                              color: AppColors.white,
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          style: AppStyles.h1,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          text,
                          style: AppStyles.text,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: AppButton(text: buttonTitle, onPressed: onPressed),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
