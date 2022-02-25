import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile({required this.date, required this.steps});
  final DateTime date;
  final int? steps;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Jiffy(date).MMMEd, style: AppStyles.textTile),
            const SizedBox(height: 4),
            Text('$steps шагов', style: AppStyles.textTileCaption),
          ],
        ),
      ),
      const SizedBox(
          width: 22,
          child: Icon(Icons.chevron_right, size: 32, color: AppColors.lightText))
    ]);
  }
}
