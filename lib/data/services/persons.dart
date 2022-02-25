import 'package:notaemato/app/cached_read_write_value.dart';
import 'package:notaemato/data/model/person.dart';
import 'package:notaemato/data/model/user.dart';
import 'package:notaemato/data/repository/persons.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

import 'auth.dart';

@lazySingleton
class PersonsService with ReactiveServiceMixin implements OnAuthListener {
  PersonsService(this._personsRepository, AuthService _authService) {
    _authService.addAuthListener(this);
    listenToReactiveValues([loading, rawPersons, _persons]);
  }
  late final PersonsRepository _personsRepository;
  final ValueNotifier<bool> loading = ValueNotifier(false);

  CachedReadWriteValue<List<PersonModel>> get rawPersons => _personsRepository.rawPersons;
  final ReactiveValue<Map<int, PersonModel>> _persons =
      ReactiveValue<Map<int, PersonModel>>({});
  Map<int, PersonModel> get persons => _persons.value;

  Future update({bool force = false}) async {
    loading.value = true;
    await rawPersons.update(force: force);
    _persons.value = _personsRepository.persons;
    loading.value = false;
  }

  @override
  void onExit() {
    _personsRepository.clean();
  }

  @override
  void onUser(UserModel user) {
    update(force: true);
  }
}
