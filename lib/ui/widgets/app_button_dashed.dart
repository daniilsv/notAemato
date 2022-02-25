import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notaemato/ui/theme/theme.dart';

class AppButtonDashed extends StatelessWidget {
  const AppButtonDashed({
    required this.onPressed,
    required this.text,
    Key? key,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        decoration: DottedDecoration(
          shape: Shape.box,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: AppPaddings.all18,
          child: Center(
            child: Text(
              text,
              style: AppStyles.textTileCaption,
            ),
          ),
        ),
      ),
    );
  }
}
