import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    required this.title,
    required this.subtitle,
    required this.eventDate,
    this.photoUrl,
  });

  final String title;
  final String subtitle;
  final String? photoUrl;
  final Jiffy? eventDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: Avatar(photoUrl: photoUrl),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyles.textSemi),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        style: AppStyles.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                        (eventDate?.dateTime.day == DateTime.now().day
                                ? 'Сегодня в ${eventDate?.Hm}'
                                : eventDate?.MEd) ??
                            '',
                        style: AppStyles.caption),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
