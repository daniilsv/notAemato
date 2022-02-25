import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button_icon.dart';
import 'package:notaemato/ui/widgets/avatar.dart';
import 'package:flutter/material.dart';

class PersonTile extends StatelessWidget {
  const PersonTile({
    Key? key,
    this.onTap,
    this.onAccept,
    this.onReject,
    this.onMenu,
    this.title,
    this.subtitle,
    this.persons,
    this.photoUrl,
    this.value,
  }) : super(key: key);

  final VoidCallback? onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onMenu;
  final String? title;
  final String? photoUrl;
  final String? subtitle;
  final String? persons;
  final bool? value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        width: 48,
        height: 48,
        child: Avatar(photoUrl: photoUrl),
      ),
      onTap: onTap,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title ?? 'Имя отсутствует', style: AppStyles.textTile),
                if (subtitle != null)
                  Text(subtitle ?? '', style: AppStyles.textTileCaption),
                if (persons != null)
                  Text(
                    'Персоны: $persons',
                    style: AppStyles.textTileCaption,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onAccept != null)
                AppButtonIcon(
                  bgColor: value ?? false ? AppColors.primary : AppColors.gray70,
                  onPressed: onAccept,
                ),
              const SizedBox(width: 12),
              if (onReject != null)
                AppButtonIcon(
                  icon: Icons.close,
                  iconColor: AppColors.gray100,
                  bgColor: AppColors.gray10,
                  onPressed: onReject,
                ),
              if (onMenu != null)
                AppButtonIcon(
                  icon: Icons.more_horiz_rounded,
                  iconColor: AppColors.gray100,
                  bgColor: AppColors.gray10,
                  onPressed: onMenu,
                ),
            ],
          )
        ],
      ),
    );
  }
}
