import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable(createFactory: false)
class RegisterRequest {
  final String email;
  final String? id;
  final String? sim;
  @JsonKey(name: 'is_subscriber')
  final bool? isSubscriber;
  final String language;

  RegisterRequest(
    this.email,
    this.language, {
    this.isSubscriber,
    this.id,
    this.sim,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
