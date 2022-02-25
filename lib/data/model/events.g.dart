// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) {
  return EventModel(
    id: json['id'] as int?,
    code: json['code'] as int?,
    q: json['q'] as int?,
    deviceTs: json['deviceTs'] as int?,
    ts: jiffyFromAny(json['ts']),
    geozoneId: json['geozoneId'] as int?,
    geozoneName: json['geozoneName'] as String?,
    lat: numOrString(json['lat']),
    lon: numOrString(json['lon']),
  );
}

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'q': instance.q,
      'deviceTs': instance.deviceTs,
      'ts': jiffyToInt(instance.ts),
      'geozoneId': instance.geozoneId,
      'geozoneName': instance.geozoneName,
      'lat': anyToDouble(instance.lat),
      'lon': anyToDouble(instance.lon),
    };
