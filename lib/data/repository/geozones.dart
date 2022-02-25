import 'package:notaemato/app/cached_read_write_value.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/geozone.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GeozonesRepository {
  GeozonesRepository(this._api) {
    geozones = CachedReadWriteValue<List<GeozoneModel>>(
      'geozones',
      defaultValue: [],
      ttl: const Duration(minutes: 3),
      update: _api.getGeozones,
      encoder: (models) => models?.map((e) => e.toJson()).toList() ?? [],
      decoder: (json) => json is List
          ? json.map<GeozoneModel>((e) => GeozoneModel.fromJson(e)).toList()
          : [],
    );
  }
  late final SocketApi _api;

  late CachedReadWriteValue<List<GeozoneModel>> geozones;

  void clean() {
    geozones.val = [];
  }
}
