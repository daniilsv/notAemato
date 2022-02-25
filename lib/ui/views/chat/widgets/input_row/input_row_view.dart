import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:supercharged/supercharged.dart';

import './input_row_view_model.dart';

class  InputRowView extends StatelessWidget {
  const InputRowView({
    required this.onSendText,
    required this.onSendAudio,
  });
  final void Function(String text) onSendText;
  final void Function(String path, int duration) onSendAudio;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InputRowViewModel>.reactive(
      viewModelBuilder: () => InputRowViewModel(
        onSendText: onSendText,
        onSendAudio: onSendAudio,
      ),
      builder: (context, model, child) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: 250.milliseconds,
                  decoration: BoxDecoration(
                    color:
                        model.isRecording ? AppColors.bottomBar : const Color(0xFFFAFAFA),
                    border: Border.all(
                      color: model.isRecording
                          ? Colors.transparent
                          : const Color.fromRGBO(0, 0, 0, 0.06),
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      SizedBox(height: model.isRecording ? 36 : 0),
                      AnimatedOpacity(
                        duration: 250.milliseconds,
                        opacity: model.isRecording ? 0 : 1,
                        child: const _TextInputRow(),
                      ),
                      if (model.isRecording) const _AudioInputRow(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          if (model.isRecording ||
                              model.textController.value.text.isNotEmpty)
                            GestureDetector(
                              onTap: model.onSend,
                              child: Container(
                                padding: const EdgeInsets.only(
                                  bottom: 10,
                                  top: 11,
                                  left: 12,
                                  right: 8,
                                ),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                ),
                                child: const Icon(
                                  Icons.send,
                                  color: AppColors.white,
                                  size: 15,
                                ),
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: model.startRecording,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 7,
                                  horizontal: 14,
                                ),
                                child: const Icon(
                                  Icons.mic,
                                  color: AppColors.primary,
                                  size: 22,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TextInputRow extends ViewModelWidget<InputRowViewModel> {
  const _TextInputRow();
  @override
  Widget build(BuildContext context, InputRowViewModel model) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            maxLength: 50,
            controller: model.textController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            cursorColor: AppColors.primary,
            maxLines: model.textController.text.split('\n').length < 5 ? null : 5,
            style: AppStyles.text,
            onChanged: model.onChanged,
            decoration: InputDecoration(
              counterText: "",
              contentPadding: model.textController.text.split('\n').length == 1
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(bottom: 8, top: 6),
              isDense: true,
              border: InputBorder.none,
              hintMaxLines: 1,
              hintStyle: AppStyles.text,
              hintText: 'Напишите сообщение',
            ),
          ),
        ),
        const SizedBox(width: 42),
      ],
    );
  }
}

class _AudioInputRow extends ViewModelWidget<InputRowViewModel> {
  const _AudioInputRow();
  @override
  Widget build(BuildContext context, InputRowViewModel model) {
    return Row(
      children: [
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Icon(
            model.isRecorded ? Icons.stop : Icons.mic,
            color: AppColors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Запись — ${model.doubleToTimeString(model.position + 0.0)}',
          style: AppStyles.text.copyWith(color: AppColors.white),
        ),
        const Spacer(),
        GestureDetector(
          onTap: model.dropRecording,
          child: Text(
            'ОТМЕНА',
            style: AppStyles.text.copyWith(color: AppColors.white),
          ),
        ),
        const SizedBox(width: 42),
      ],
    );
  }
}
