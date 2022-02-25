import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_card.dart';
import 'package:notaemato/ui/widgets/app_icon_button.dart';
import 'package:flutter/material.dart';

class ActionsCard extends StatelessWidget {
  const ActionsCard({
    required this.onBackCallTap,
    required this.onAlarmClocksTap,
    required this.onMovingTap,
    required this.onDoNotDisturbTap,
    required this.onGeozonesTap,
    required this.onSearchTap,
    required this.onTakePhotoTap,
    required this.onGalleryTap,
    // @required this.key
  });
  final Function onBackCallTap;
  final Function onAlarmClocksTap;
  final Function onMovingTap;
  final Function onTakePhotoTap;
  final Function onSearchTap;
  final Function onDoNotDisturbTap;
  final Function onGeozonesTap;
  final Function onGalleryTap;
  // final GlobalKey key;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: key,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Действия', style: AppStyles.titleCard),
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: AppColors.gray10),
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
            },
            children: [
              TableRow(children: [
                AppIconButton(
                  title: 'Обратный звонок',
                  icon: Icons.phone,
                  onTap: onBackCallTap,
                  padding: const EdgeInsets.all(16),
                ),
                AppIconButton(
                  title: 'Сделать фото',
                  icon: Icons.photo_camera,
                  onTap: onTakePhotoTap,
                  padding: const EdgeInsets.all(16),
                )
              ]),
              TableRow(children: [
                AppIconButton(
                  title: 'Поиск часов',
                  icon: Icons.search,
                  onTap: onSearchTap,
                  padding: const EdgeInsets.all(16),
                ),
                AppIconButton(
                  title: 'Не беспокоить',
                  icon: Icons.do_not_disturb_on,
                  onTap: onDoNotDisturbTap,
                  padding: const EdgeInsets.all(16),
                )
              ]),
              TableRow(children: [
                AppIconButton(
                  title: 'Будильник',
                  icon: Icons.notifications,
                  onTap: onAlarmClocksTap,
                  padding: const EdgeInsets.all(16),
                ),
                AppIconButton(
                  title: 'Геозоны',
                  icon: Icons.place,
                  onTap: onGeozonesTap,
                  padding: const EdgeInsets.all(16),
                )
              ]),
              TableRow(children: [
                AppIconButton(
                  title: 'Перемещения',
                  icon: Icons.moving,
                  onTap: onMovingTap,
                  padding: const EdgeInsets.all(16),
                ),
                AppIconButton(
                  title: 'Галерея',
                  icon: Icons.photo_library,
                  onTap: onGalleryTap,
                  padding: const EdgeInsets.all(16),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
