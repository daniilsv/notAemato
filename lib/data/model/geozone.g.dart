// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geozone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeozoneModel _$GeozoneModelFromJson(Map<String, dynamic> json) {
  return GeozoneModel(
    center: const LatLngSerialiser()
        .fromJson(json['center'] as Map<String, dynamic>?),
    name: json['name'] as String?,
    id: json['id'] as int?,
    type: json['type'] as String?,
    radius: json['radius'] as int?,
    props: json['props'] as Map<String, dynamic>?,
  );
}

Map<String, dynamic> _$GeozoneModelToJson(GeozoneModel instance) =>
    <String, dynamic>{
      'center': const LatLngSerialiser().toJson(instance.center),
      'name': instance.name,
      'id': instance.id,
      'type': instance.type,
      'radius': instance.radius,
      'props': instance.props,
    };
