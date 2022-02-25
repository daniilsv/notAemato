// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'images.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceImage _$DeviceImageFromJson(Map<String, dynamic> json) {
  return DeviceImage(
    imageId: json['imageId'] as int?,
    inbound: json['inbound'] as bool?,
    name: json['name'] as String?,
    size: json['size'] as int?,
    ts: json['ts'] as int?,
  );
}

Map<String, dynamic> _$DeviceImageToJson(DeviceImage instance) =>
    <String, dynamic>{
      'imageId': instance.imageId,
      'inbound': instance.inbound,
      'name': instance.name,
      'size': instance.size,
      'ts': instance.ts,
    };
