import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';

class CallButton extends StatelessWidget {
  const CallButton({
    required this.icon,
    this.color = Colors.transparent,
    this.iconColor = Colors.white,
    this.iconSize = 28,
    this.padding = 20,
    this.onTap,
    this.label,
  });
  final IconData icon;
  final String? label;
  final Color color;
  final Color iconColor;
  final double iconSize;
  final double padding;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final _icon = InkResponse(
      onTap: onTap,
      borderRadius: BorderRadius.circular(iconSize / 2 + padding),
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
    if (label == null) return _icon;
    return Column(
      children: [
        _icon,
        const SizedBox(height: 8),
        Text(label!, style: AppStyles.whiteTextLabel),
      ],
    );
  }
}
