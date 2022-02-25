import 'package:notaemato/app/cached_read_write_value.dart';
import 'package:notaemato/data/model/geozone.dart';
import 'package:notaemato/data/model/user.dart';
import 'package:notaemato/data/repository/geozones.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

import 'auth.dart';

@lazySingleton
class GeozonesService with ReactiveServiceMixin implements OnAuthListener {
  GeozonesService(this._geozonesRepository, AuthService _authService) {
    _authService.addAuthListener(this);
    listenToReactiveValues([loading, geozones]);
  }
  late final GeozonesRepository _geozonesRepository;
  final ValueNotifier<bool> loading = ValueNotifier(false);

  CachedReadWriteValue<List<GeozoneModel>> get geozones => _geozonesRepository.geozones;

  Future update({bool force = false}) async {
    loading.value = true;
    await geozones.update(force: force);
    loading.value = false;
  }

  @override
  void onExit() {
    _geozonesRepository.clean();
  }

  @override
  void onUser(UserModel user) {
    update(force: true);
  }
}
