import 'package:json_annotation/json_annotation.dart';

enum ConsultationType {
  @JsonKey()
  online,
  @JsonKey()
  offline,
}
