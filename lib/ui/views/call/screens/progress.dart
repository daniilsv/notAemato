import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/call/widgets/call_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:stacked/stacked.dart';

import '../call_viewmodel.dart';

class ProgressCallView extends ViewModelWidget<CallViewModel> {
  const ProgressCallView();

  @override
  Widget build(BuildContext context, CallViewModel model) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: RTCVideoView(
                model.firstRenderer,
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
              child: Text(model.time, style: AppStyles.textCallWhite18),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CallButton(
                  icon: Icons.mic,
                  iconColor: model.mute ? Colors.yellow : Colors.white,
                  onTap: model.toggleMute,
                ),
                CallButton(
                  icon: model.speakers ? Icons.volume_off : Icons.volume_up,
                  iconColor: model.speakers ? Colors.yellow : Colors.white,
                  onTap: model.toggleSpeaker,
                ),
                CallButton(
                  icon:model.camera ? Icons.videocam :  Icons.videocam_off,
                  iconColor: model.camera ? Colors.white :  Colors.yellow,
                  onTap: model.toggleNoCamera,
                ),
              ],
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
                ),
                CallButton(
                  icon: Icons.change_circle_outlined,
                  onTap: model.flipCamera,
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
        Positioned(
          right: 0,
          top: 0,
          width: 150,
          height: 150,
          child: GestureDetector(
            onTap: model.switchRenderers,
            child: RTCVideoView(model.secondRenderer),
          ),
        ),
      ],
    );
  }
}
