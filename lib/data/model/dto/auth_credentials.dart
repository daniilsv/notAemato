import 'package:json_annotation/json_annotation.dart';

part 'auth_credentials.g.dart';

@JsonSerializable()
class AuthCredentials {
  final String? email;
  final String? password;

  AuthCredentials({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() => _$AuthCredentialsToJson(this);

  factory AuthCredentials.fromJson(Map<String, dynamic> json) =>
      _$AuthCredentialsFromJson(json);
}
