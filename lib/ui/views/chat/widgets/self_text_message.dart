import 'package:notaemato/data/model/messages.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'audio_widget.dart';

class SelfTextMessage extends StatelessWidget {
  SelfTextMessage({required this.message, this.audio})
      : super(key: ValueKey(message.mailId));
  final MessageModel message;
  final String? audio;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (message.text != null)
      child = Text(message.text ?? '', style: AppStyles.whiteTextLabel, softWrap: true);
    else
      child = AudioMessageWidget(
        message: message,
        isSelf: true,
      );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            Jiffy.unix(message.ts!).format('H:mm').trim(),
            style: AppStyles.text.copyWith(fontSize: 12, color: AppColors.darkText),
          ),
          const SizedBox(width: 7),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: child,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
