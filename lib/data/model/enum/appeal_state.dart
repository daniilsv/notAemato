import 'package:json_annotation/json_annotation.dart';

enum AppealState {
  @JsonKey()
  open,
  @JsonKey()
  closed,
  @JsonKey()
  pending,
}
