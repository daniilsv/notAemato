import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SizedApp extends StatefulWidget {
  const SizedApp({
    required this.child,
    this.ratio,
    this.size,
    this.overrided = false,
  });
  final Widget child;
  final Size? size;
  final double? ratio;
  final bool overrided;
  @override
  _SizedAppState createState() => _SizedAppState();
}

class _SizedAppState extends State<SizedApp> {
  final w = WidgetsBinding.instance!.window;
  double get windowRatio => w.devicePixelRatio;
  Size get windowSize =>
      Size(w.physicalSize.width - w.viewInsets.left - w.viewInsets.right,
          w.physicalSize.height - w.viewInsets.top - w.viewInsets.bottom) /
      w.devicePixelRatio;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(SizedApp oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.overrided != true) return widget.child;
    final Size bigSize = Size(max(widget.size!.width, windowSize.width),
        max(widget.size!.height, windowSize.height));
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 2,
      constrained: false,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Placeholder(
            fallbackWidth: 1.3 * bigSize.width,
            fallbackHeight: 1.3 * bigSize.height,
            color: Colors.grey,
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 50,
            child: Text(
              '${widget.size!.width.toInt()}x${widget.size!.height.toInt()} in '
              '${windowSize.width.toInt()}x${windowSize.height.toInt()}\n'
              '${widget.ratio} in $windowRatio',
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            ),
          ),
          Positioned(
            left: 10,
            top: 100,
            child: MediaQuery(
              data: MediaQueryData(
                size: widget.size!,
                devicePixelRatio: widget.ratio!,
              ),
              child: Builder(
                builder: (context) => Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(border: Border.all()),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
