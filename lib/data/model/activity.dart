import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

@JsonSerializable()
class ActivityModel {
  int? age;
  int? weight;
  int? dailyStepsGoal;
  int? ts;
  List<ActivityDays>? days;

  ActivityModel({
    this.age,
    this.weight,
    this.dailyStepsGoal,
    this.ts,
    this.days,
  });
  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);

  factory ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);
}

@JsonSerializable()
class ActivityDays {
  double? distance;
  double? kcal;
  int? steps;
  int? ts;

  ActivityDays({
    this.distance,
    this.kcal,
    this.steps,
    this.ts,
  });
  Map<String, dynamic> toJson() => _$ActivityDaysToJson(this);

  factory ActivityDays.fromJson(Map<String, dynamic> json) => _$ActivityDaysFromJson(json);
}
