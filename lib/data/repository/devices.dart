import 'package:notaemato/app/cached_read_write_value.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DevicesRepository {
  DevicesRepository(this._api) {
    devices = CachedReadWriteValue<List<DeviceModel>>(
      'devices',
      defaultValue: [],
      ttl: const Duration(minutes: 3),
      update: _updateDevices,
      encoder: (models) => models?.map((e) => e.toJson()).toList() ?? [],
      decoder: (json) => json is List
          ? json.map<DeviceModel>((e) => DeviceModel.fromJson(e)).toList()
          : [],
    );
  }
  late final SocketApi _api;

  late CachedReadWriteValue<List<DeviceModel>> devices;

  Future<List<DeviceModel>?> _updateDevices() async {
    final newVal = await _api.getObjects();
    return newVal.objects;
  }

  void clean() {
    devices.val = [];
  }
}
