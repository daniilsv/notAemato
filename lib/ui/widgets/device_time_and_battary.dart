import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';

class DeviceTimeAndBattery extends StatelessWidget {
  const DeviceTimeAndBattery(
      {required this.lastActiveTime, required this.battaryPercent, this.active});
  final bool? active;
  final int? battaryPercent;
  final int? lastActiveTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          // TODO time
          Jiffy(DateTime.fromMillisecondsSinceEpoch(
                  lastActiveTime ?? DateTime.now().millisecondsSinceEpoch))
              .fromNow(), //TODO error?
          style: AppStyles.light12,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: SizedBox(
            width: 4,
            height: 4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gray80,
              ),
            ),
          ),
        ),
        SvgPicture.asset(
          AppIcons.battery,
          height: 12,
          width: 12,
          color: active ?? true ? AppColors.green : AppColors.gray80,
        ),
        const SizedBox(width: 4),
        if (battaryPercent != null)
          Text(
            // TODO charge
            '$battaryPercent%',
            style: AppStyles.light12,
          ),
      ],
    );
  }
}
