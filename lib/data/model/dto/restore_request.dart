import 'package:json_annotation/json_annotation.dart';

part 'restore_request.g.dart';

@JsonSerializable(createFactory: false)
class RestoreRequest {
  final String email;

  RestoreRequest(
    this.email,
  );

  Map<String, dynamic> toJson() => _$RestoreRequestToJson(this);
}
