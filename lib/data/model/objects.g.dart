// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'objects.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectsModel _$ObjectsModelFromJson(Map<String, dynamic> json) {
  return ObjectsModel()
    ..objects = (json['objects'] as List<dynamic>?)
        ?.map((e) => DeviceModel.fromJson(e as Map<String, dynamic>))
        .toList()
    ..my = (json['my'] as List<dynamic>?)?.map((e) => e as int).toList();
}

Map<String, dynamic> _$ObjectsModelToJson(ObjectsModel instance) =>
    <String, dynamic>{
      'objects': instance.objects,
      'my': instance.my,
    };
