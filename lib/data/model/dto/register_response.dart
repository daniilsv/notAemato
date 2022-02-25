import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable(createToJson: false)
class RegisterResponse {
  final int? result;

  RegisterResponse(this.result);

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}
