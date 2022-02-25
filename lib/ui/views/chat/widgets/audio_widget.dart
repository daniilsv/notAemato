import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/messages.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AudioMessageWidget extends StatefulWidget {
  const AudioMessageWidget({
    required this.message,
    this.isSelf = false,
  });
  final MessageModel message;
  final bool isSelf;
  @override
  _AudioMessageWidgetState createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  bool playing = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  late List<double> amplitudes;
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('audio-message');
  String? localPath;

  @override
  void initState() {
    audioPlayer.current.listen((current) {
      if (!mounted) return;
      if (localPath != null && current?.audio.audio.path == localPath) {
        duration = current?.audio.duration ?? Duration.zero;
        playing = true;
      } else {
        position = Duration.zero;
        playing = false;
      }
      setState(() {});
    });
    audioPlayer.currentPosition.listen((Duration p) {
      if (!mounted) return;
      if (localPath != null &&
          audioPlayer.current.value?.audio.assetAudioPath == localPath)
        setState(() => position = p);
    });
    audioPlayer.isPlaying.listen((bool playing) {
      if (!mounted) return;
      if (localPath != null &&
          audioPlayer.current.value?.audio.assetAudioPath ==
              localPath) if (mounted) setState(() => playing);
    });
    amplitudes = List.generate(20, (index) => Random().nextInt(20) + 5.0);
    super.initState();
  }

  Future<void> start() async {
    final appDocDirectory = await getTemporaryDirectory();
    localPath = '${appDocDirectory.path}/mail-${widget.message.mailId}.mp3';
    final file = File(localPath!);
    if (!file.existsSync()) {
      final msg = await locator<SocketApi>().getMessageData(widget.message.mailId);
      await file.writeAsBytes(base64Decode(msg?.data ?? ''));
    }
    audioPlayer.open(Audio.file(localPath!));
    position = Duration.zero;
    setState(() => playing = true);
  }

  void pause() {
    audioPlayer.pause();
    position = Duration.zero;
    setState(() => playing = false);
  }

  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  String doubleToTimeString(double seconds) {
    final minutes = (seconds / 60).floor();
    return '$minutes:${twoDigits(seconds.floor() - minutes * 60)}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => playing ? pause() : start(),
          child: Container(
            width: 22,
            margin: const EdgeInsets.only(
              right: 11,
            ),
            child: Icon(
              playing ? Icons.pause : Icons.play_arrow,
              color: widget.isSelf ? AppColors.white : AppColors.primary,
            ),
          ),
        ),
        Row(
          children: List.generate(
            20,
            (index) => Container(
              margin: const EdgeInsets.only(right: 2),
              constraints: const BoxConstraints(
                maxWidth: 3,
                minWidth: 1.5,
              ),
              height: amplitudes[index],
              decoration: BoxDecoration(
                color: (widget.isSelf ? AppColors.white : AppColors.primary).withOpacity(
                  duration.inSeconds > 0 &&
                          index < 20 * position.inSeconds / duration.inSeconds
                      ? 1.0
                      : 0.54,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        if (duration.inSeconds > 0)
          Container(
            width: 35,
            margin: const EdgeInsets.only(left: 12),
            child: AutoSizeText(
              doubleToTimeString((duration.inSeconds - position.inSeconds) + .0),
              style: AppStyles.text.copyWith(
                color: widget.isSelf ? AppColors.white : AppColors.darkText,
              ),
            ),
          ),
      ],
    );
  }
}
