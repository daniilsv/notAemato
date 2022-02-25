import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';

import 'back_button.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    required this.title,
    Key? key,
    this.canPop = false,
    this.withClose = false,
    this.height = 62,
    this.textPadding = EdgeInsets.zero,
  }) : super(key: key);
  final String title;
  final bool canPop;
  final bool withClose;
  final double height;
  final EdgeInsets textPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (canPop) ...[
              const AppBackButton(),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Padding(
                padding: textPadding,
                child: Text(
                  title,
                  style: AppStyles.h1,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            if (canPop) const SizedBox(width: 48),
            if (withClose) ...[
              const SizedBox(width: 16),
              const AppBackButton(
                  icon: Icon(
                Icons.close,
                color: AppColors.gray100,
                size: 14,
              )),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, height);
}
