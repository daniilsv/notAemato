import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/call/widgets/call_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../call_viewmodel.dart';

class OutgoingCallView extends ViewModelWidget<CallViewModel> {
  const OutgoingCallView();

  @override
  Widget build(BuildContext context, CallViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: RTCVideoView(
            model.localRenderer,
            mirror: model.mirror,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
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
          child: Text('Исходящий видеозвонок', style: AppStyles.textCallWhite18),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 68),
            CallButton(
              icon: Icons.call_end,
              color: AppColors.red,
              onTap: model.decline,
              label: 'Отменить',
            ),
            CallButton(
              icon: Icons.change_circle_outlined,
              onTap: model.flipCamera,
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
