import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/services/navigator.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/device/device_view.dart';
import 'package:notaemato/ui/widgets/device_time_and_battary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({
    required this.device,
    this.isButton,
    Key? key,
  }) : super(key: key);
  final bool? isButton;
  final DeviceModel? device;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isButton ?? false
          ? () {
              locator<NavigatorService>().changePage(0);
              locator<NavigatorService>().navigatorKeys[0].currentState
                ?..popUntil((route) => route.isFirst)
                ..push(DeviceViewRoute(device));
            }
          : null,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          // TODO Device Name remove
          device!.type ?? 'Device Name',
        ),
        subtitle: DeviceTimeAndBattery(
            lastActiveTime: device!.states!.coordTs,
            battaryPercent: device!.batteryPercent,
            active: device!.online),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: device!.online ?? false ? AppColors.green : AppColors.gray80,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            AppIcons.watch,
            height: 24,
            width: 24,
          ),
        ),
      ),
    );
  }
}
