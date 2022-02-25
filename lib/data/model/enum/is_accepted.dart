import 'package:json_annotation/json_annotation.dart';

enum IsAccepted {
  @JsonKey()
  active,
  @JsonKey()
  declined,
  @JsonKey()
  waiting,
}
