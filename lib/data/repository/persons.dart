import 'package:notaemato/app/cached_read_write_value.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/person.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PersonsRepository {
  PersonsRepository(this._api) {
    rawPersons = CachedReadWriteValue<List<PersonModel>>(
      'persons',
      defaultValue: [],
      ttl: const Duration(minutes: 3),
      update: () => _api?.getPersons([]),
      onValue: (value) {
        persons
          ..clear()
          ..addAll(Map.fromEntries(value!.map((e) => MapEntry(e.personId!, e))));
      },
      encoder: (models) => models?.map((e) => e.toJson()).toList() ?? [],
      decoder: (json) => json is List
          ? json.map<PersonModel>((e) => PersonModel.fromJson(e)).toList()
          : [],
    );
  }
  final SocketApi? _api;

  late CachedReadWriteValue<List<PersonModel>> rawPersons;
  final Map<int, PersonModel> persons = {};

  void clean() {
    rawPersons.val = [];
  }
}
