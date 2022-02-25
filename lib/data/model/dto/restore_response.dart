import 'package:json_annotation/json_annotation.dart';

part 'restore_response.g.dart';

@JsonSerializable(createToJson: false)
class RestoreResponse {
  final int? result;

  RestoreResponse(this.result);

  factory RestoreResponse.fromJson(Map<String, dynamic> json) =>
      _$RestoreResponseFromJson(json);
}
