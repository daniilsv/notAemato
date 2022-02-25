// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryPoint _$HistoryPointFromJson(Map<String, dynamic> json) {
  return HistoryPoint(
    lat: (json['lat'] as num?)?.toDouble(),
    lon: (json['lon'] as num?)?.toDouble(),
    speed: (json['speed'] as num?)?.toDouble(),
    stepCount: json['stepCount'] as int?,
    lbs: json['lbs'] as bool?,
    ts: json['ts'] as int?,
  );
}

Map<String, dynamic> _$HistoryPointToJson(HistoryPoint instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
      'speed': instance.speed,
      'stepCount': instance.stepCount,
      'lbs': instance.lbs,
      'ts': instance.ts,
    };
