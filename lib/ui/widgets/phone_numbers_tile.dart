import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button_icon.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/material.dart';

class PhoneNumbersTile extends StatelessWidget {
  const PhoneNumbersTile(
      {Key? key, this.onReject, this.name, this.number, this.sos, this.onSosSelection})
      : super(key: key);

  final VoidCallback? onReject;
  final String? name;
  final String? number;
  final int? sos;
  final VoidCallback? onSosSelection;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.phone, color: AppColors.gray100),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name ?? 'Имя отсутствует', style: AppStyles.textTile),
              Text(number ?? 'Телефон отсутствует', style: AppStyles.textTileCaption),
              if (onSosSelection == null && sos != 0) Text('SOS #$sos', style: AppStyles.sos),
            ],
          ),
        ),
        const SizedBox(width: 12),
        if (onReject != null)
          AppButtonIcon(
            icon: Icons.close,
            iconColor: AppColors.gray100,
            bgColor: AppColors.gray10,
            onPressed: onReject,
          ),
        if (onSosSelection != null)
          Tappable(
            onPressed: onSosSelection,
                      child: Row(
              children: [
                Text(
                  sos == 0 ? 'Выбрать' : '№$sos',
                  style: AppStyles.textTile,
                ),
                const AppButtonIcon(
                  icon: Icons.expand_more_outlined,
                  iconColor: AppColors.gray100,
                  bgColor: Colors.transparent,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
