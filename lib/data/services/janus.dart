import 'dart:async';

import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/services/push.dart';
import 'package:notaemato/ui/views/call/call_view.dart';
import 'package:notaemato/ui/widgets/app_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:janus_client/JanusClient.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

enum CallingState { idle, incoming, outgoing, progress }

@singleton
class JanusService with ReactiveServiceMixin {
  JanusService() {
    // _authService.addAuthListener(this);
    listenToReactiveValues([state, duration]);
    state.addListener(onStateChanged);
  }
  late JanusSession session;
  late JanusPlugin plugin;
  Completer<bool> _registered = Completer<bool>();

  late RTCVideoRenderer? localRenderer = RTCVideoRenderer();
  late RTCVideoRenderer? remoteRenderer = RTCVideoRenderer();
  late SharedPreferences prefs;

  final ValueNotifier<CallingState> state = ValueNotifier(CallingState.idle);
  RTCSessionDescription? incomingJsep;

  Timer? _durationTimer;
  final ValueNotifier<int> duration = ValueNotifier(0);
  OverlayEntry? entry;
  bool initing = false;
  bool mirror = true;
  late String userName;

  void addOverlay() {
    entry ??= OverlayEntry(builder: (context) => const CallView());
    if (entry!.mounted) return;
    StackedService.navigatorKey!.currentState!.overlay!.insert(entry!);
  }

  void removeOverlay() {
    try {
      if (entry?.mounted ?? false) entry?.remove();
      // ignore: empty_catches
    } on Object {}
  }

  Future<void> initClient(String wsHost, String token, String localUsername) async {
    if (_registered.isCompleted || initing) return;
    initing = true;
    final ws = WebSocketJanusTransport(
      url: Uri(scheme: 'wss', host: wsHost, port: 8989).toString(),
      pingInterval: const Duration(seconds: 1),
    );
    final client = JanusClient(
      token: token,
      transport: ws,
    );
    prefs = await SharedPreferences.getInstance();
    session = await client.createSession();
    plugin = await session.attach(JanusPlugins.VIDEO_CALL);
    ws.sink?.done.then((value) => destroy());
    plugin.messages?.listen(onMessage);
    plugin.send(data: {"request": "register", "username": localUsername});
    plugin.remoteStream?.listen((event) {
      remoteRenderer!.srcObject = event;
      final track = event.getAudioTracks()[0];
      track
        ..setVolume(5)
        ..setMicrophoneMute(false);
    });
  }

  void onStateChanged() {
    if (state.value == CallingState.progress) {
      _durationTimer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          duration.value = duration.value + 1;
        },
      );
    } else {
      duration.value = 0;
      _durationTimer?.cancel();
      _durationTimer = null;
    }
  }

  Future<void> flipCamera() async {
    plugin.switchCamera();
    mirror = !mirror;
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> setMute(bool mute) async {
    final track = localRenderer!.srcObject!.getAudioTracks()[0];
    Helper.setMicrophoneMute(mute, track);
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> setSpeaker(bool enable) async {
    final track = remoteRenderer!.srcObject!.getAudioTracks()[0];
    track
      ..setVolume(100)
      ..enableSpeakerphone(enable);
  }

  // ignore: avoid_positional_boolean_parameters
  Future<void> setCamera(bool enable) async {
    if (enable) {
      plugin.send(data: {"request": "set", "video": true});
    } else {
      plugin.send(data: {"request": "set", "video": false});
    }
  }

  Future<void> makeCall(String remoteUsername) async {
    if (!_registered.isCompleted) await _registered.future;
    await _initRenderers();
    userName = remoteUsername;
    state.value = CallingState.outgoing;
    final offerToCall = await plugin.createOffer();
    addOverlay();
    logger.wtf(offerToCall.sdp);
    plugin.send(
      data: {"request": "call", "username": remoteUsername},
      jsep: offerToCall,
    );
  }

  Future<void> answer() async {
    // FlutterRingtonePlayer.stop();
    // locator<PushService>().cancelCallNotif();
    await _initRenderers();
    await plugin.handleRemoteJsep(incomingJsep!);
    final offer = await plugin.createAnswer();
    plugin.send(
      data: {"request": "accept"},
      jsep: offer,
    );
  }

  Future<void> decline() async {
    try {
      plugin.send(data: {'request': 'hangup'});
      // ignore: empty_catches
    } on Object {}
    destroy();
  }

  Future<void> hangup() async {
    try {
      plugin.send(data: {'request': 'hangup'});
      // ignore: empty_catches
    } on Object {}
    plugin.hangup();
    destroy();
  }

  void destroy() {
    // FlutterRingtonePlayer.stop();
    try {
      plugin.dispose();
    } on Object catch (e) {
      logger.e(e);
    }
    try {
      session.dispose();
    } on Object catch (e) {
      logger.e(e);
    }
    // if (!_registered.isCompleted) _registered.completeError(0);
    // locator<PushService>().cancelCallNotif();
    _registered = Completer<bool>();
    removeOverlay();
    initing = false;
    state.value = CallingState.idle;
    prefs.setString('host', '');
    prefs.setString('token', '');
    prefs.setString('caller', '');
    // localRenderer!.delegate.dispose();
    // remoteRenderer!.delegate.dispose();
    // localRenderer!.dispose();
    // remoteRenderer!.dispose();
  }

  // @override
  // void onExit() {
  //   destroy();
  // }

  // @override
  // void onUser(UserModel? user) {}

  Future<void> _initRenderers() async {
    localRenderer!.initialize();
    remoteRenderer!.initialize();
    localRenderer!.srcObject = await plugin.initializeMediaDevices(mediaConstraints: {
      "audio": true,
      "video": true,
    });
  }

  Future<void> onMessage(EventMessage _event) async {
    notifyListeners();
    initing = false;
    final result = _event.event?['plugindata']?['data']?["result"];
    final error = _event.event?['plugindata']?['data']?['error'];
    final errorCode = _event.event?['plugindata']?['data']?['error_code'];
    final event = result?["event"];
    if (_event.event['janus'] == 'hangup') {
      destroy();
      showAppDialog(subtitle: _event.event['reason']);
    }
    logger.wtf(_event);
    logger.wtf(result);
    logger.wtf(error);
    logger.wtf(event);
    if (event == null) {
      if (error != null) {
        if (errorCode != 478) {
          if (errorCode == 476) {
            plugin.pollingActive = true;
            notifyListeners();
            return;
          } else {
            destroy();
            showAppDialog(subtitle: error);
            return;
          }
        } else {
          await makeCall(userName);
        }
      }
    }
    switch (event) {
      case 'registered':
        if (!_registered.isCompleted) _registered.complete(true);
        plugin.pollingActive = true;
        break;
      case 'hangup':
        destroy();
        break;
      case 'accepted':
        logger.v(_event.event['jsep']);
        logger.v(_event.event['jsep']?['sdp']);
        if (_event.event['jsep'] != null) {
          final response = _event.event['jsep'];
          final String sdp = response['sdp'];
          final String type = response['type'];
          plugin.handleRemoteJsep(RTCSessionDescription(sdp, type));
        }
        state.value = CallingState.progress;
        break;
      case 'incomingcall':
        if (_event.event['jsep'] != null) {
          final response = _event.event['jsep'];
          final String sdp = response['sdp'];
          final String type = response['type'];
          incomingJsep = RTCSessionDescription(sdp, type);
        }
        if (prefs.getString('callEvent') == '' || prefs.getString('callEvent') == null) {
          state.value = CallingState.incoming;
        } else if (prefs.getString('callEvent') == 'accept') {
          answer();
        } else if (prefs.getString('callEvent') == 'reject') {
          decline();
          break;
        }
        prefs.setString('callEvent', '');
        break;
    }
  }
}
