import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef Future<dynamic> CallEventHandler(
  String sessionId,
  String caller,
  String callee,
  String callerName,
);

class CallKit {
  static const MethodChannel _channel = MethodChannel('call_kit');

  static CallKit get instance => _getInstance();
  static CallKit? _instance;
  static String tag = "CallKit";

  static CallKit _getInstance() {
    if (_instance == null) {
      _instance = CallKit._internal();
    }
    return _instance!;
  }

  factory CallKit() => _getInstance();

  CallKit._internal();

  static Function(
    String sessionId,
    int caller,
    int callee,
    String callerName,
  )? onCallRejectedWhenTerminated;

  static Function(
    String sessionId,
    String caller,
    String callee,
    String callerName,
  )? onCallAcceptedWhenTerminated;

  static CallEventHandler? _onCallAccepted;
  static CallEventHandler? _onCallRejected;

  void init({
    CallEventHandler? onCallAccepted,
    CallEventHandler? onCallRejected,
  }) {
    _onCallAccepted = onCallAccepted;
    _onCallRejected = onCallRejected;
    initMessagesHandler();
  }

  static void initMessagesHandler() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  static Future<void> showCallNotification({
    required String? sessionId,
    required String? caller,
    required String? callee,
    required String? callerName,
  }) async {
    if (!Platform.isAndroid) return;

    return _channel.invokeMethod("showCallNotification", {
      'session_id': sessionId,
      'callee': caller,
      'caller': callee,
      'caller_name': callerName,
    });
  }

  static Future<void> reportCallAccepted({
    required String? sessionId,
  }) async {
    if (!Platform.isAndroid) return;

    return _channel.invokeMethod("reportCallAccepted", {
      'session_id': sessionId,
    });
  }

  static Future<void> reportCallEnded({
    required String? sessionId,
  }) async {
    if (!Platform.isAndroid) return;

    return _channel.invokeMethod("reportCallEnded", {
      'session_id': sessionId,
    });
  }

  static Future<String> getCallState({
    required String? sessionId,
  }) async {
    if (!Platform.isAndroid) return Future.value('CallState.UNKNOWN');

    return _channel.invokeMethod("getCallState", {
      'session_id': sessionId,
    }).then((state) {
      return state.toString();
    });
  }

  static Future<void> setCallState({
    required String? sessionId,
    required String? callState,
  }) async {
    return _channel.invokeMethod("setCallState", {
      'session_id': sessionId,
      'call_state': callState,
    });
  }

  static Future<Map<String, dynamic>?> getCallData({
    required String? sessionId,
  }) async {
    if (!Platform.isAndroid) return Future.value();

    return _channel.invokeMethod("getCallData", {
      'session_id': sessionId,
    }).then((data) {
      if (data == null) {
        return Future.value(null);
      }
      return Future.value(Map<String, dynamic>.from(data));
    });
  }

  static Future<void> clearCallData({
    required String? sessionId,
  }) async {
    if (!Platform.isAndroid) return Future.value();

    return _channel.invokeMethod("clearCallData", {
      'session_id': sessionId,
    });
  }

  static Future<String?> getLastCallId() async {
    if (!Platform.isAndroid) return Future.value();

    return _channel.invokeMethod("getLastCallId");
  }

  static Future<void> setOnLockScreenVisibility({
    required bool? isVisible,
  }) async {
    if (!Platform.isAndroid) return;

    return _channel.invokeMethod("setOnLockScreenVisibility", {
      'is_visible': isVisible,
    });
  }

  static Future<dynamic> _handleMethod(MethodCall call) async {
    final Map map = call.arguments.cast<String, dynamic>();
    final prefs = await SharedPreferences.getInstance();
    switch (call.method) {
      case 'onCallAccepted':
        prefs.setString('callEvent', 'accept');

        break;
      case 'onCallRejected':
        prefs.setString('callEvent', 'reject');

        break;
      default:
        throw UnsupportedError("Unrecognized JSON message");
    }
    return Future.value();
  }
}
