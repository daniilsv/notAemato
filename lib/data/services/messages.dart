import 'dart:io';

import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/messages.dart';
import 'package:notaemato/data/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

import 'auth.dart';
import 'devices.dart';
import 'persons.dart';

@lazySingleton
class MessagesService with ReactiveServiceMixin implements OnAuthListener {
  MessagesService(this._devicesService, this._personsService, this._api) {
    _devicesService.devices.addListener(update);
    _personsService.rawPersons.addListener(update);
    _api.subscribe('object_inbound_voice_mail', onVoiceMessage);
    listenToReactiveValues([_updater, loading]);
  }
  final ValueNotifier<bool> loading = ValueNotifier(false);
  final ValueNotifier<bool> _updater = ValueNotifier(false);
  final SocketApi _api;
  final PersonsService _personsService;
  final DevicesService _devicesService;
  final messages = <DeviceModel, List<MessageModel>>{};
  Directory? dir;

  void pingUpdater() => _updater.value = !_updater.value;

  Future update({bool? force}) async {
    dir ??= await getApplicationDocumentsDirectory();
    loading.value = true;
    messages.clear();
    for (final device in _devicesService.devices.val!) {
      await updateByDevice(device);
    }
    pingUpdater();
    loading.value = false;
  }

  Future updateByDevice(DeviceModel device, {bool ping = false}) async {
    try {
      final m = await _api.getMessages(oid: device.oid, limit: 100, withText: true);
      if (m is List && m!.isNotEmpty) messages[device] = [...m];
      // ignore: empty_catches
    } on Object {}
    if (ping) pingUpdater();
  }

  @override
  void onExit() {
    messages.clear();
  }

  @override
  void onUser(UserModel user) {
    update(force: true);
  }

  void onVoiceMessage(Map<String, dynamic> message) {
    addMessage(
      message['oid'],
      MessageModel(
        ts: message['mail']['ts'],
        text: message['mail']['text'],
        inbound: message['mail']['inbound'],
        mailId: message['mail']['mailId'],
      ),
    );
  }

  void addMessage(int? oid, MessageModel message) {
    final device = messages.keys.firstWhere(
      (element) => element.oid == oid,
      orElse: () => DeviceModel(oid: oid),
    );
    messages[device] ??= [];
    messages[device]!.insert(0, message);
    pingUpdater();
  }
}
