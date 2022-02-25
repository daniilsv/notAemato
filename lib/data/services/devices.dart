import 'package:notaemato/app/cached_read_write_value.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/user.dart';
import 'package:notaemato/data/repository/devices.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

import 'auth.dart';

@lazySingleton
class DevicesService with ReactiveServiceMixin implements OnAuthListener {
  DevicesService(this._devicesRepository, AuthService _authService) {
    _authService.addAuthListener(this);
    listenToReactiveValues([loading, devices]);
  }
  late final DevicesRepository _devicesRepository;
  final ValueNotifier<bool> loading = ValueNotifier(false);

  CachedReadWriteValue<List<DeviceModel>> get devices => _devicesRepository.devices;

  Future update({bool force = false}) async {
    loading.value = true;
    await devices.update(force: force);
    loading.value = false;
  }

  @override
  void onExit() {
    _devicesRepository.clean();
  }

  @override
  void onUser(UserModel user) {
    update(force: true);
  }
}
