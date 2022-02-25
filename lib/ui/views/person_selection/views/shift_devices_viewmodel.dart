import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/person.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/data/services/persons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import 'complete.dart';

class ShiftDevicesViewModel extends BaseViewModel {
  ShiftDevicesViewModel(this.context) {
    shiftDevices =
        ModalRoute.of(context)!.settings.arguments as Map<PersonModel, DeviceModel>?;
  }
  // Services
  final SocketApi api = locator<SocketApi>();
  final PersonsService personsService = locator<PersonsService>();
  final DevicesService devicesService = locator<DevicesService>();

  // Constants
  Map<PersonModel, DeviceModel>? shiftDevices;
  BuildContext context;

  // Controllers

  // Variables

  // Logic

  Future onReady() async {
    //
  }

  Future<void> save() async {
    MetricaService.event('device_shift', {
      'oid': shiftDevices!.values.last.oid,
      'personId': shiftDevices!.keys.first.personId,
    });
    setBusy(true);
    final ret = await api.setObjectProfile(shiftDevices!.values.first.oid, 0);
    logger.i(ret);
    final ret2 = await api.setObjectProfile(
        shiftDevices!.values.last.oid, shiftDevices!.keys.first.personId);
    logger.i(ret2);
    if (ret2 != null) {
      await devicesService.update(force: true);
      setBusy(false);
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (_) => AddPersonCompleteView(name: shiftDevices!.keys.first.name),
        ),
      );
    }
    setBusy(false);
  }
}
