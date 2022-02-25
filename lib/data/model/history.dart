import 'package:json_annotation/json_annotation.dart';

part 'history.g.dart';

@JsonSerializable()
class HistoryPoint {
  double? lat;
  double? lon;
  double? speed;
  int? stepCount;
  bool? lbs;
  int? ts;

  HistoryPoint({this.lat, this.lon, this.speed, this.stepCount, this.lbs, this.ts});

  Map<String, dynamic> toJson() => _$HistoryPointToJson(this);

  factory HistoryPoint.fromJson(Map<String, dynamic> json) =>
      _$HistoryPointFromJson(json);
}
