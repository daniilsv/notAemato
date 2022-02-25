import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_card.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({
    required this.onOffTap,
    required this.onRebootTap,
    required this.onSettingsTap,
  });
  final Function onSettingsTap;
  final Function onRebootTap;
  final Function onOffTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Устройство', style: AppStyles.titleCard),
          const SizedBox(height: 16),
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Tappable(
                onPressed: onSettingsTap as void Function()?,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.settings,
                        size: 28,
                        color: AppColors.gray80,
                      ),
                      const SizedBox(width: 16),
                      Text('Настройки', style: AppStyles.textLabel)
                    ],
                  ),
                ),
              ),
              Tappable(
                onPressed: onRebootTap as void Function()?,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.restart_alt,
                        size: 28,
                        color: AppColors.gray80,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Перезагрузить',
                        style: AppStyles.textLabel,
                      )
                    ],
                  ),
                ),
              ),
              Tappable(
                onPressed: onOffTap as void Function()?,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.power_settings_new,
                        size: 28,
                        color: AppColors.gray80,
                      ),
                      const SizedBox(width: 16),
                      Text('Выключить', style: AppStyles.textLabel)
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
