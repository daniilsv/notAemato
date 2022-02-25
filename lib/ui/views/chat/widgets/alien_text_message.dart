import 'package:notaemato/data/model/messages.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'audio_widget.dart';

class AlienTextMessage extends StatelessWidget {
  AlienTextMessage({required this.message, this.audio, this.play})
      : super(key: ValueKey(message.mailId));
  final MessageModel message;
  final String? audio;
  final bool? play;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (message.text != null)
      child = Text(message.text ?? '', style: AppStyles.whiteTextLabel);
    else
      child = AudioMessageWidget(message: message);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray80,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: child,
              ),
            ],
          ),
          const SizedBox(width: 7),
          Text(
            Jiffy.unix(message.ts!).format('H:mm').trim(),
            style: AppStyles.text.copyWith(fontSize: 12, color: AppColors.darkText),
          ),
        ],
      ),
    );
  }
}
