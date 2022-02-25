import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class MessageTile extends StatelessWidget {
  const MessageTile(
      {required this.title,
      required this.subtitle,
      required this.lastMessageDate,
      this.photoUrl,
      this.newMessageCount});

  final String title;
  final String? subtitle;
  final String? photoUrl;
  final DateTime? lastMessageDate;
  final int? newMessageCount;

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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppStyles.textSemi,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (lastMessageDate != null)
                      Text(
                          lastMessageDate!.day == DateTime.now().day
                              ? 'Сегодня в ${Jiffy(lastMessageDate).Hm}'
                              : Jiffy(lastMessageDate).MEd,
                          style: AppStyles.caption),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(subtitle!, style: AppStyles.caption),
                    if (newMessageCount! > 0)
                      SizedBox(
                        height: 24,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: AppBorderRadius.card,
                            color: AppColors.red,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                                child: Text('$newMessageCount',
                                    style: AppStyles.whiteTextLabel)),
                          ),
                        ),
                      ),
                    if (newMessageCount == null)
                      const SizedBox(
                        height: 24,
                      ),
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
