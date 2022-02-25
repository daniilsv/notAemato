import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {Key? key,
      this.label,
      this.controller,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.onTap,
      this.error,
      this.onChanged,
      this.hintText,
      this.isButton,
      this.onSubmited,
      })
      : super(key: key);
  final String? label;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final String? error;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmited;
  final String? hintText;
  final bool? isButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.gray10,
            borderRadius: AppBorderRadius.textField,
            border: Border.all(color: error == null ? AppColors.gray10 : AppColors.error),
          ),
          child: TextField(
            onSubmitted: onSubmited,
            onChanged: onChanged,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              labelText: label,
              labelStyle: AppStyles.textLabel,
              contentPadding: isButton ?? false
                  ? const EdgeInsets.symmetric(horizontal: 4, vertical: 13)
                  : const EdgeInsets.all(4),
              isDense: true,
              suffixIconConstraints: const BoxConstraints(maxWidth: 36),
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              error!,
              style: AppStyles.textError,
            ),
          )
        ]
      ],
    );
  }
}
