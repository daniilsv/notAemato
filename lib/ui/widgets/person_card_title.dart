import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';

import 'device_time_and_battary.dart';

class PersonCardTitle extends StatelessWidget {
  const PersonCardTitle(
      {required this.name,
      required this.deviceName,
      required this.lastActiveTime,
      required this.battaryPercent,
      required this.active});
  final String name;
  final String deviceName;
  final int? lastActiveTime;
  final int? battaryPercent;
  final bool? active;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppStyles.titleCard),
              const SizedBox(height: 4),
              Text(deviceName, style: AppStyles.secondaryCard),
            ],
          ),
        ),
        const SizedBox(width: 8),
        DeviceTimeAndBattery(
          lastActiveTime: lastActiveTime,
          battaryPercent: battaryPercent,
          active: active,
        ),
      ],
    );
  }
}
