import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/call/widgets/call_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../call_viewmodel.dart';

class IncomingCallView extends ViewModelWidget<CallViewModel> {
  const IncomingCallView();

  @override
  Widget build(BuildContext context, CallViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.15),
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          AutoSizeText(
            model.personName,
            maxLines: 2,
            style: AppStyles.h1White,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Center(
            child: Text('Входящий видеозвонок', style: AppStyles.textCallWhite18),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CallButton(
                icon: Icons.call_end,
                color: AppColors.red,
                onTap: model.decline,
                label: 'Отклонить',
              ),
              CallButton(
                icon: Icons.videocam,
                color: AppColors.green,
                onTap: model.answer,
                label: 'Принять',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
