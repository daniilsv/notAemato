import 'package:notaemato/data/model/dto/auth_credentials.dart';
import 'package:notaemato/data/model/user.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserRepository {
  final stage = ReadWriteValue<String?>('stage', null);
  final authModel = ReadWriteValue<AuthCredentials?>(
    'auth',
    null,
    encoder: (model) => model?.toJson() ?? {},
    decoder: (json) => json is Map<String, dynamic>
        ? json == {}
            ? null
            : AuthCredentials.fromJson(json)
        : null,
  );
  final userModel = ReadWriteValue<UserModel?>(
    'user',
    null,
    encoder: (model) => model?.toJson() ?? {},
    decoder: (json) => json is Map<String, dynamic>
        ? json == {}
            ? null
            : UserModel.fromJson(json)
        : null,
  );
}
