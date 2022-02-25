import 'dart:async';
import 'dart:convert';

import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/user.dart';
import 'package:notaemato/data/model/videocall.dart';
import 'package:notaemato/data/services/persons.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/root/root_viewmodel.dart';
import 'package:callkit/CallKit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import 'auth.dart';
import 'janus.dart';

Future<void> processCallNotification(Map<String, dynamic> data) async {
  CallKit.showCallNotification(
    sessionId: DateTime.now().toString(),
    callee: '123',
    caller: '321',
    callerName: 'Notaemato Connect', //TODO Name caller
  );
  return;
}

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  logger.wtf(message.data);
  try {
    final msgData = message.data;
    msgData['data'] = jsonDecode(msgData['data']);
    msgData['callee'] = jsonDecode(msgData['callee']);
    msgData['caller'] = jsonDecode(msgData['caller']);
    final call = VideocallResponseModel.fromJson(msgData);
    logger.wtf(msgData);
    if (call.data!.janus!.hostname != null) {
      CallKit.initMessagesHandler();
      processCallNotification(message.data);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('host', call.data!.janus!.hostname!);
      prefs.setString('token', call.data!.janus!.token!);
      prefs.setString('caller', call.callee!.uid!);
      prefs.setString('callerName', 'Notaemato Connect');
      locator<RootViewModel>().onReady(); //TODO Name caller
      return;
    }
  } on Object catch (e) {
    logger.e(e);
  }
  FirebaseMessaging.onMessageOpenedApp;
  return Future.value();
}

class PushLog {
  DateTime? date;
  Map<String, dynamic>? notification;
  Map<String, dynamic>? data;
}

@singleton
class PushService
    with ReactiveServiceMixin, WidgetsBindingObserver
    implements OnAuthListener {
  PushService(AuthService authService) {
    authService.addAuthListener(this);
    listenToReactiveValues([logs]);
    _api.subscribe('auth', (_) => _sendToken());
    WidgetsBinding.instance!.addObserver(this);
  }
  final _api = locator<SocketApi>();
  StreamSubscription? _onMessage;
  StreamSubscription? _onOpened;
  final logs = ReactiveList<PushLog>();
  final messaging = FirebaseMessaging.instance;
  late SharedPreferences prefs;
  String? token;
  Completer _rootCompleter = Completer();
  int? callNotifId;

  late FlutterLocalNotificationsPlugin _localNotifications;

  Future<void> _configure() async {
    await messaging.requestPermission();
    prefs = await SharedPreferences.getInstance();

    _onMessage ??= FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      logs.insert(
        0,
        PushLog()
          ..date = DateTime.now()
          ..notification = {
            "title": message.notification?.title,
            "body": message.notification?.body,
          }
          ..data = message.data,
      );
      logger.d('message');
      logger.d(jsonEncode(message.data));

      _showNotification(message);
    });
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      logger.d(jsonEncode(initialMessage.data));
      _onSelectNotification(initialMessage);
    }
    _onOpened ??= FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.d('PUSH launch');
      logger.d(jsonEncode(message.data));
      _onSelectNotification(message);
    });
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    _localNotifications = FlutterLocalNotificationsPlugin();
    await _localNotifications.initialize(
      InitializationSettings(
        android: const AndroidInitializationSettings('mipmap/ic_launcher'),
        iOS: IOSInitializationSettings(
          onDidReceiveLocalNotification: (id, title, body, payload) =>
              _onSelectLocalNotification(payload, id, title, body),
        ),
      ),
      // onSelectNotification: _onSelectLocalNotification,
    );
    token = await messaging.getToken();
    messaging.onTokenRefresh.listen(_sendToken);
    if (token != null) {
      _sendToken(token);
      logger.d('PUSH TOKEN: $token');
    }
  }

  void _showNotification(RemoteMessage message) {
    try {
      final msgData = message.data;
      msgData['data'] = jsonDecode(msgData['data']);
      msgData['callee'] = jsonDecode(msgData['callee']);
      msgData['caller'] = jsonDecode(msgData['caller']);
      final call = VideocallResponseModel.fromJson(msgData);
      logger.wtf(msgData);
      if (call.data!.janus!.hostname != null) {
        locator<JanusService>().initClient(
          call.data!.janus!.hostname!,
          call.data!.janus!.token!,
          call.callee!.uid!,
        );
        locator<JanusService>().addOverlay();
        // FlutterRingtonePlayer.play(
        //   android: AndroidSounds.ringtone,
        //   ios: IosSounds.bell,
        //   looping: true,
        // );
        // locator<JanusService>().state.value = CallingState.incoming;
        callNotifId = DateTime.now().millisecondsSinceEpoch % 100000;
        // _localNotifications.show(
        //   callNotifId!,
        //   message.notification!.title,
        //   message.notification!.body ?? '',
        //   _channelCall,
        // );
        return;
      }
    } on Object catch (e) {
      logger.e(e);
    }
    final data = message.data;
    String? title;
    String? body;
    if (message.notification != null) {
      title = message.notification!.title;
      body = message.notification!.body;
    }
    final int id = DateTime.now().millisecondsSinceEpoch % 100000;
    // _localNotifications.show(
    //   id,
    //   title ?? '',
    //   body ?? '',
    //   _channelNotify,
    //   payload: json.encode(data),
    // );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.detached)
      return;

    final isBackground = state == AppLifecycleState.paused;

    if (!isBackground) {
      makeCall();
    }
  }

  Future makeCall() async {
    final host = prefs.getString('host');
    final token = prefs.getString('token');
    final caller = prefs.getString('caller');
    final callEvent = prefs.getString('callEvent');
    if (host != '' && host != null) {
      await locator<JanusService>().initClient(
        host,
        token ?? '',
        caller ?? '',
      );
      locator<JanusService>().addOverlay();
      // FlutterRingtonePlayer.play(
      //   android: AndroidSounds.ringtone,
      //   ios: IosSounds.bell,
      //   looping: true,
      // );
    }
  }

  Future _onSelectNotification(RemoteMessage message) async {
    if (!_rootCompleter.isCompleted) await _rootCompleter.future;
    final msgData = message.data;
    msgData['data'] = jsonDecode(msgData['data']);
    msgData['callee'] = jsonDecode(msgData['callee']);
    msgData['caller'] = jsonDecode(msgData['caller']);
    final call = VideocallResponseModel.fromJson(msgData);
    if (call.data!.janus!.hostname != null) {
      JanusService().initClient(
        call.data!.janus!.hostname!,
        call.data!.janus!.token!,
        call.callee!.uid!,
      );
      locator<JanusService>().addOverlay();
      // FlutterRingtonePlayer.play(
      //   android: AndroidSounds.ringtone,
      //   ios: IosSounds.bell,
      //   looping: true,
      // );
      // locator<JanusService>().state.value = CallingState.incoming;
      return;
    }
    logger.i(message);
  }

  Future _onSelectLocalNotification(String? payload,
      [int? id, String? title, String? body]) async {
    if (!_rootCompleter.isCompleted) await _rootCompleter.future;
    logger.i(payload);
  }

  Future<void> _sendToken([String? token]) async {
    token ??= this.token;
    if (token != null) _api.addFcm(token);
  }

  void cancelCallNotif() {
    _localNotifications.cancel(callNotifId ?? 0);
  }

  @override
  void onExit() {
    _rootCompleter = Completer();
    _onMessage?.cancel();
    _onOpened?.cancel();
    messaging.deleteToken();
    _localNotifications.cancelAll();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void onUser(UserModel user) {
    _configure();
    if (!_rootCompleter.isCompleted) _rootCompleter.complete();
  }
}
