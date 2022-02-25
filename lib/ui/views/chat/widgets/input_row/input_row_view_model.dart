import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

class InputRowViewModel extends BaseViewModel {
  InputRowViewModel({
    this.onSendText,
    this.onSendAudio,
  });
  final void Function(String)? onSendText;
  final void Function(String, int)? onSendAudio;

  final TextEditingController textController = TextEditingController();

  bool isRecording = false;
  bool isRecorded = false;
  late String recordingPath;

  int position = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void onChanged(String value) {
    notifyListeners();
  }

  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  String doubleToTimeString(double seconds) {
    final minutes = (seconds / 60).floor();
    return '$minutes:${twoDigits(seconds.floor() - minutes * 60)}';
  }

  Future<void> startRecording() async {
    final hasPermissions =
        await Permission.microphone.isGranted && await Permission.storage.isGranted;
    if (!hasPermissions) {
      await [Permission.microphone, Permission.storage].request();
      // if (!await AudioRecorder.hasPermissions) {
      //   Get.snackbar('Необходимо разрешение',
      //       'Для записи голосовых сообщений необходимо предоставить доступ к микрофону',
      //       backgroundColor: HDColors.primary, colorText: Colors.white);
      // }
      return;
    }
    isRecording = true;
    isRecorded = false;
    notifyListeners();
    final appDocDirectory = await getTemporaryDirectory();
    recordingPath = '${appDocDirectory.path}/${const Uuid().v4()}.mp3';
    if (!RecordMp3.instance.start(recordingPath, (type) {})) {
      return;
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (position == 10) {
          isRecorded = true;
          stopRecording();
          return;
        }
        position++;
        notifyListeners();
      },
    );
  }

  Future<void> stopRecording() async {
    if (!isRecorded) {
      isRecording = false;
      position = 0;
    }
    _timer?.cancel();
    notifyListeners();
    RecordMp3.instance.stop();
  }

  void dropRecording() {
    isRecorded = false;
    stopRecording();
  }

  Future<void> onSend() async {
    if (isRecording) {
      if (!isRecorded) await stopRecording();
      try {
        final bytes = await File(recordingPath).readAsBytes();
        if (bytes.isNotEmpty) onSendAudio!(base64Encode(bytes), position);
      } on Object {}
      if (isRecorded) {
        dropRecording();
      }
      return;
    }
    if (textController.text.isNotEmpty) onSendText!(textController.text.trim());
    textController.text = '';
    notifyListeners();
  }
}
