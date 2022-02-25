import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notaemato/ui/theme/theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding,
    this.color=Colors.white,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final Color color;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? AppPaddings.v10h20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
        boxShadow: const [AppShadows.dashboard],
      ),
      child: child,
    );
  }
}
