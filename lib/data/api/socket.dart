import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/model/activity.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/dto/auth_credentials.dart';
import 'package:notaemato/data/model/dto/socket_error.dart';
import 'package:notaemato/data/model/enum/is_accepted.dart';
import 'package:notaemato/data/model/events.dart';
import 'package:notaemato/data/model/geozone.dart';
import 'package:notaemato/data/model/history.dart';
import 'package:notaemato/data/model/images.dart';
import 'package:notaemato/data/model/messages.dart';
import 'package:notaemato/data/model/objects.dart';
import 'package:notaemato/data/model/person.dart';
import 'package:notaemato/data/model/person_access_request.dart';
import 'package:notaemato/data/model/pulse.dart';
import 'package:notaemato/data/model/user.dart';
import 'package:notaemato/data/model/videocall.dart';
import 'package:notaemato/data/repository/user.dart';
import 'package:notaemato/data/services/auth.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:jiffy/jiffy.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

import '../../env.dart';

@lazySingleton
class SocketApi {
  SocketApi(this._userRepository) {
    _userRepository.stage.listen((v) => init());
    _userRepository.authModel.listen((v) => onLogout());
  }

  final uuid = const Uuid();
  final UserRepository _userRepository;
  IOWebSocketChannel? _socket;
  Completer _connecting = Completer();

  final _eventCallbacks = <String, List<Function(Map<String, dynamic>)>>{};
  final _callbacks = <String, Completer<Map<String, dynamic>>>{};

  void init() {
    close();
    _socket = IOWebSocketChannel.connect(Env.wsUrl[_userRepository.stage.val ?? 'prod']!);
    _socket!.stream.listen(
      onMessage,
      onDone: () {
        logger.w(['disconnected', _socket?.closeCode, _socket?.closeReason]);
        close();
        if (_userRepository.authModel.val == null) return;
        Future<void>.delayed(const Duration(seconds: 1)).then((value) {
          auth();
        });
      },
      onError: (err) {
        logger.w(['ws error', err.toString()]);
      },
    );
    _connecting.complete();
    silentLogger.i('connected');
  }

  void close() {
    _connecting = Completer();
    for (final com in _callbacks.values) com.completeError(SocketError.noInternet);
    _callbacks.clear();
    _socket?.sink.close();
    _socket = null;
  }

  void onLogout() {
    if (_userRepository.authModel.val != null) return;
    close();
  }

  void subscribe(String event, Function(Map<String, dynamic>) callback) {
    _eventCallbacks[event] ??= [];
    _eventCallbacks[event]!.add(callback);
  }

  void unsubscribe(String event, Function(Map<String, dynamic>) callback) {
    if (_eventCallbacks[event] == null) return;
    _eventCallbacks[event]!.remove(callback);
  }

  void onMessage(dynamic message) {
    silentLogger.i(message);
    final msg = jsonDecode(message) as Map<String, dynamic>;
    // silentLogger.i(msg);
    final data = msg['data'];
    if (msg['cmd'] == 'auth')
      for (final callback in _eventCallbacks['auth'] ?? []) callback(data);
    if (msg['uid'] == null) {
      if (_eventCallbacks[msg['cmd']] != null)
        for (final callback in _eventCallbacks[msg['cmd']] ?? []) callback(data);
      else
        for (final callback in _eventCallbacks[''] ?? []) callback(data);
      return;
    }
    final callback = _callbacks[msg['uid']];
    if (msg['uid'] == null || callback == null) return;
    if (data != null && data['result'] == 1) {
      callback.completeError(SocketError.fromJson(data));
    } else {
      callback.complete(data);
    }
    _callbacks.remove(msg['uid']);
  }

  Future<Map<String, dynamic>?> send(
    String cmd, {
    Map<String, dynamic>? data,
    bool wait = true,
  }) async {
    final index = uuid.v4();
    if (_socket == null) init();
    await _connecting.future;
    final d = <String, dynamic>{
      'uid': index,
      'cmd': cmd,
    };
    if (data != null) {
      data.removeWhere((key, value) => value == null);
      if (data.isNotEmpty) d['data'] = data;
    }
    final json = jsonEncode(d);
    _socket!.sink.add(json);
    logger.v(json);
    if (wait == true) {
      _callbacks[index] = Completer<Map<String, dynamic>>();
      return _callbacks[index]!.future;
    }
    return null;
  }

  Future<UserModel?> auth([AuthCredentials? cred]) async {
    cred ??= _userRepository.authModel.val;
    if (cred?.email == null) return null;
    final _res = await send('auth', data: {
      'username': cred!.email,
      'password': cred.password,
      'web': false,
      'v': 1,
      'version': '1.4.26'
    });
    final res = UserModel.fromJson(_res!);
    locator<AuthService>().saveAuthCred(cred, res);
    return res;
  }

  Future<void> addFcm(String token) async {
    final id = await getDeviceDetails();
    send('enable_push_notifications', wait: false, data: {
      'provider': 'Google',
      'instance': token,
      'appId': 2,
      'debug': kDebugMode,
      if (id['android']! != '') 'androidId': id['android']!,
      if (id['ios']! != '') 'iosId': id['ios']!
    });
  }

  Future<Map<String, String>> getDeviceDetails() async {
    String ios = '';
    String android = '';
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final data = await deviceInfoPlugin.androidInfo;
        android = data.androidId;
      } else if (Platform.isIOS) {
        final data = await deviceInfoPlugin.iosInfo;
        ios = data.identifierForVendor;
      }
    } on PlatformException {}
    return {'ios': ios, 'android': android};
  }

  Future<ObjectsModel> getObjects() async {
    final _res = await send('get_object_map');
    return ObjectsModel.fromJson(_res!);
  }

  Future<bool> setSkytag(String skytag) async {
    await send('change_skytag', data: {'skytag': skytag});
    return true;
  }

  Future<bool> setVideocallProfile({
    String? name,
    bool isActive = true,
  }) async {
    try {
      await send('set_videocall_profile_data', data: {
        'name': name,
        'isActive': isActive,
      });
      return true;
    } on SocketError {
      return false;
    }
  }

  Future<String?> getUploadProfilePhotoUrl() async {
    final _res = await send('make_profile_photo_token');
    return _res!['photoUploadUrl'];
  }

  Future<DeviceModel> addDevice(String regCode, String name) async {
    final _res = await send('add_device', data: {'reg_code': regCode, 'name': name});
    return DeviceModel.fromJson(_res!['object']);
  }

  Future? deleteDevice(String imei) async {
    return send('delete_device', data: {'deviceId': imei.substring(4)});
  }

  Future<String?> getUploadPersonPhotoUrl(int? id) async {
    final _res = await send('make_person_photo_token', data: {'person_id': id});
    return _res!['photoUploadUrl'];
  }

  Future<int?> upsertPerson(PersonModel person) async {
    final method =
        person.personId == null ? 'create_person_profile' : 'update_person_profile';
    final _res = await send(method, data: person.toJson());
    return _res!['personId'];
  }

  Future<int?> setObjectProfile(int? deviceId, int? personId) async {
    final _res =
        await send('set_object_profile', data: {'person_id': personId, 'oid': deviceId});
    return _res!['result'];
  }

  Future<int?> clearShareBadgeCounter() async {
    final _res = await send('clear_share_badge_counter', data: {});
    return _res!['result'];
  }

  Future<ActivityModel> getActivityHistory(int? deviceId, DateTime date, int days) async {
    final _res = await send('get_activity_history', data: {
      'oid': deviceId,
      'ts': Jiffy.unix(date.millisecondsSinceEpoch)
          .endOf(Units.DAY)
          .dateTime
          .millisecondsSinceEpoch,
      'pastDays': days
    });
    return ActivityModel.fromJson(_res!);
  }

  Future<PulseModel> getPulseHistory(int? deviceId, DateTime date, int days) async {
    final _res = await send('get_pulse_history', data: {
      'oid': deviceId,
      'ts': Jiffy.unix(date.millisecondsSinceEpoch)
          .endOf(Units.DAY)
          .dateTime
          .millisecondsSinceEpoch,
      'pastDays': days
    });
    return PulseModel.fromJson(_res!);
  }

  Future<String?> restartDevice(int? deviceId) async {
    final _res = await send('restart_object', data: {
      'oid': deviceId,
    });
    return _res!['response'];
  }

  Future<int?> deletePersonProfile(int? personId) async {
    final _res = await send('delete_person_profile', data: {
      'person_id': personId,
    });
    return _res!['result'];
  }

  Future<int?> setObjectSosPhones(int? oid, List<SosPhone>? sosPhones) async {
    final _res =
        await send('set_object_sos_phones', data: {'oid': oid, 'phones': sosPhones});
    return _res!['result'];
  }

  Future<int?> setObjectPhonebook(int? oid, List<PhonebookPhone> phonebook) async {
    final _res = await send('set_object_phonebook', data: {
      'oid': oid,
      'dialRepeatCount': '1',
      'phones': phonebook.map((e) => {'phone': e.phone, 'name': e.name}).toList()
    });
    return _res!['result'];
  }

  Future<int?> setObjectAlarmClock(int? oid, List<AlarmClock>? alarms) async {
    final _res =
        await send('set_object_alarm_clock', data: {'oid': oid, 'alarms': alarms});
    return _res!['result'];
  }

  Future<int?> setObjectDndMode(int? oid, List<DndMode>? dnd) async {
    final _res = await send('set_object_dnd_mode', data: {'oid': oid, 'dndMode': dnd});
    return _res!['result'];
  }

  Future<String?> shutdownDevice(int? deviceId) async {
    final _res = await send('shutdown_object', data: {
      'oid': deviceId,
    });
    return _res!['response'];
  }

  Future<int?> requestObjectMonitorCallback(int? deviceId, String phone) async {
    final _res = await send('request_object_monitor_callback',
        data: {'oid': deviceId, 'phone': phone});
    return _res!['result'];
  }

  Future<int?> changeObjectCard(
    int? deviceId,
    String phoneNumber, {
    String? deviceName,
    int? enableGeozoneEnterAlert,
    int? enableGeozoneLeaveAlert,
  }) async {
    final _res = await send('change_object_card', data: {
      'oid': deviceId,
      'card': {
        if (deviceName != null) 'name': deviceName,
        'simNumber1': phoneNumber,
        if (enableGeozoneEnterAlert != null)
          'enableGeozoneEnterAlert': enableGeozoneEnterAlert,
        if (enableGeozoneLeaveAlert != null)
          'enableGeozoneLeaveAlert': enableGeozoneLeaveAlert
      }
    });
    return _res!['result'];
  }

  Future<int?> requestDeviceAccess(String regCode, String role) async {
    final _res = await send('request_person_access',
        data: {'reg_code': regCode, 'role_title': role});
    return _res!['result'];
  }

  Future? sendPersonAccess(
    String personId,
    String role, {
    String? email,
    String? phone,
  }) async {
    return send('send_person_access', data: {
      'person_id': personId,
      'role_title': role,
      'phone': phone,
      'email': email,
    });
  }

  Future<List<PersonAccessRequest>?> getPersonAccessRequests() async {
    final _res = await send('get_person_access_requests');
    return _res!['requests']
        .map<PersonAccessRequest>((req) => PersonAccessRequest.fromJson(req))
        .toList();
  }

  Future<int> processPersonAccessRequest(int? requestId, {IsAccepted? isAccepted}) async {
    final _res = await send('process_person_access_request', data: {
      'person_access_id': requestId,
      'is_accepted': isAccepted.toString().split('.').last,
    });
    return _res!['result'];
  }

  Future? deletePersonAccess(String accessId) async {
    return send('delete_person_access', data: {
      'person_access_id': accessId,
    });
  }

  Future<List<PersonModel>?> getPersons(List<int> personIds) async {
    final _res = await send('get_person_profiles', data: {'person_ids': personIds});
    return _res!['person_profiles']
        .map<PersonModel>((req) => PersonModel.fromJson(req))
        .toList();
  }

  Future<List<GeozoneModel>?> getGeozones() async {
    final _res = await send('get_geozone_list');
    return _res!['geozones']
        .map<GeozoneModel>((req) => GeozoneModel.fromJson(req))
        .toList();
  }

  Future<GeozoneModel> upsertGeozone(GeozoneModel geozone) async {
    final method = geozone.id == null ? 'create_circle_geozone' : 'edit_circle_geozone';
    final _res = await send(method, data: {
      if (geozone.id != null) 'id': geozone.id,
      'center': {'lon': geozone.center!.longitude, 'lat': geozone.center!.latitude},
      'name': geozone.name,
      'radius': geozone.radius!.toInt(),
      'props': {
        'enableEnterAlert': '1',
        'enableLeaveAlert': '1',
        'affectAllUserObjects': '1'
      }
    });
    return GeozoneModel.fromJson(_res!);
  }

  Future? deleteGeozone(int? geozoneId) async {
    return send('delete_geozone', data: {'id': geozoneId});
  }

  Future<List<MessageModel>?> getMessages({int? oid, int? limit, bool? withText}) async {
    final _res = await send('get_object_voice_mails',
        data: {'oid': oid, 'limit': limit, 'withText': withText});
    return _res!['list'].map<MessageModel>((req) => MessageModel.fromJson(req)).toList();
  }

  Future<List<EventModel>> getEvents(int? oid, int? limit) async {
    final _res = await send('get_object_events', data: {
      'oid': oid,
      'describe': true,
      'id': 0,
      'direction': 'forward',
      'filter': [
        // 120, 302, 1601, 1701, 1901, 2001, 2002, 2003, 2004, 2005, 2006
      ],
      'limit': limit,
    });
    return _res!['events'].map<EventModel>((req) => EventModel.fromJson(req)).toList();
  }

  Future<MessageData?> getMessageData(int? mailId) async {
    final _res =
        await send('get_object_voice_mail', data: {'mailId': mailId, 'type': 'mp3'});
    return _res!['result'] == 0
        ? MessageData(data: _res['content'], message: MessageModel.fromJson(_res['mail']))
        : null;
  }

  Future<int> getPhotoFromDevice(int? oid) async {
    final _res = await send('capture_photo', data: {'oid': oid});
    return _res!['result'];
  }

  Future<int> clarifyObjectLocation(int? oid) async {
    final _res = await send('clarify_object_location', data: {'oid': oid});
    return _res!['result'];
  }

  Future<int?> enableObjectFindZummer(int? oid) async {
    final _res = await send('enable_object_find_zummer', data: {'oid': oid});
    return _res!['result'];
  }

  Future<MessageModel> sendTextMessageToObject(int? oid, String text) async {
    final _res =
        await send('send_text_message_to_object', data: {'oid': oid, 'text': text});
    return MessageModel(
      ts: DateTime.now().millisecondsSinceEpoch,
      inbound: false,
      text: text,
      mailId: _res!['mailId'],
    );
  }

  Future<int?> setObjectCheckinPeriod(int? oid, int? period) async {
    final _res =
        await send('set_object_checkin_period', data: {'oid': oid, 'seconds': period});
    return _res!['result'];
  }

  Future<List<HistoryPoint>> getObjectTrackStepPoints(int? oid) async {
    final _res = await send('get_object_track_step_points', data: {
      'oid': oid,
      'toDate': Jiffy.unix(DateTime.now().millisecondsSinceEpoch)
          .endOf(Units.DAY)
          .dateTime
          .millisecondsSinceEpoch,
      'fromDate': Jiffy.unix(
              DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch)
          .endOf(Units.DAY)
          .dateTime
          .millisecondsSinceEpoch
    });
    return _res!['points']
            .map<HistoryPoint>((req) => HistoryPoint.fromJson(req))
            .toList() ??
        [];
  }

  Future<MessageModel> sendAudioMessageToObject(int? oid, String content) async {
    final _res = await send('send_voice_mail_to_object', data: {
      'oid': oid,
      'content': content,
      'type': 'mp3',
    });
    return MessageModel(
      ts: DateTime.now().millisecondsSinceEpoch,
      inbound: false,
      mailId: _res!['mailId'],
    );
  }

  Future<List<DeviceImage>> getObjectImages(int? oid) async {
    final _res = await send('get_object_images', data: {
      'oid': oid,
      'limit': 999,
    });
    return _res!['list'].map<DeviceImage>((req) {
          final img = DeviceImage.fromJson(req);
          img.name = '${_res['url']}${img.name}';
        }).toList() ??
        [];
  }

  Future<VideocallResponseModel?> createVideocall(int? oid) async {
    final _res = await send('create_videocall', data: {'oid': oid});
    return VideocallResponseModel.fromJson(_res!['videocall']);
  }
}
