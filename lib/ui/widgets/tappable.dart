import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tappable extends StatelessWidget {
  const Tappable({required this.child, Key? key, this.onPressed, this.color})
      : super(key: key);
  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      minSize: 0,
      padding: EdgeInsets.zero,
      child: DefaultTextStyle(
        style: TextStyle(color: color ?? Colors.black),
        child: child,
      ),
    );
  }
}
