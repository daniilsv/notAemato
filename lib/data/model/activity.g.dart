// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) {
  return ActivityModel(
    age: json['age'] as int?,
    weight: json['weight'] as int?,
    dailyStepsGoal: json['dailyStepsGoal'] as int?,
    ts: json['ts'] as int?,
    days: (json['days'] as List<dynamic>?)
        ?.map((e) => ActivityDays.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'age': instance.age,
      'weight': instance.weight,
      'dailyStepsGoal': instance.dailyStepsGoal,
      'ts': instance.ts,
      'days': instance.days,
    };

ActivityDays _$ActivityDaysFromJson(Map<String, dynamic> json) {
  return ActivityDays(
    distance: (json['distance'] as num?)?.toDouble(),
    kcal: (json['kcal'] as num?)?.toDouble(),
    steps: json['steps'] as int?,
    ts: json['ts'] as int?,
  );
}

Map<String, dynamic> _$ActivityDaysToJson(ActivityDays instance) =>
    <String, dynamic>{
      'distance': instance.distance,
      'kcal': instance.kcal,
      'steps': instance.steps,
      'ts': instance.ts,
    };
