import 'dart:collection';
import 'dart:io';

import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/events.dart';
import 'package:notaemato/data/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

import 'auth.dart';
import 'devices.dart';
import 'persons.dart';

@lazySingleton
class EventsService with ReactiveServiceMixin implements OnAuthListener {
  EventsService(this._devicesService, this._personsService, this._api) {
    _devicesService.devices.addListener(update);
    _personsService.rawPersons.addListener(update);
    _api.subscribe('', onEvent);
    listenToReactiveValues([_updater, loading]);
  }
  final ValueNotifier<bool> loading = ValueNotifier(false);
  final ValueNotifier<bool> _updater = ValueNotifier(false);
  final SocketApi _api;
  final PersonsService _personsService;
  final DevicesService _devicesService;
  final _events = SplayTreeSet<Event>((a, b) =>
      (b.event?.ts?.dateTime.millisecondsSinceEpoch ?? 0)
          .compareTo(a.event?.ts?.dateTime.millisecondsSinceEpoch ?? 0));
  final events = <Event>[];
  Directory? dir;

  void pingUpdater() {
    events
      ..clear()
      ..addAll(_events);

    _updater.value = !_updater.value;
  }

  Future update({bool force = false}) async {
    dir ??= await getApplicationDocumentsDirectory();
    loading.value = true;
    _events.clear();
    for (final device in _devicesService.devices.val!) {
      await updateByDevice(device);
    }
    pingUpdater();
    loading.value = false;
  }

  Future updateByDevice(DeviceModel device, {bool ping = false}) async {
    try {
      final m = await _api.getEvents(device.oid, 50);
      _events.addAll(m.map((e) => Event(device: device, event: e)));
      // ignore: empty_catches
    } on Object {}
    if (ping) pingUpdater();
  }

  @override
  void onExit() {
    events.clear();
  }

  @override
  void onUser(UserModel user) {
    update(force: true);
  }

  void onEvent(Map<String, dynamic> event) {
    update(force: true);
    // final device = _devicesService.devices.val!.firstWhere(
    //   (element) => element.oid == event['oid'],
    //   orElse: () => DeviceModel(oid: event['oid']),
    // );
    // final _event = Event(device: device, event: EventModel.fromJson(event));
    // _events.add(_event);
    pingUpdater();
  }
}
