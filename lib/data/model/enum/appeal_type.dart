import 'package:json_annotation/json_annotation.dart';

enum AppealType {
  @JsonKey()
  online,
  @JsonKey()
  offline,
  @JsonKey()
  chat,
}
