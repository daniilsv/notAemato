// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonModel _$PersonModelFromJson(Map<String, dynamic> json) {
  return PersonModel(
    personId: json['person_id'] as int?,
    name: json['name'] as String?,
    weight: json['weight'] as int?,
    height: json['height'] as int?,
    dateOfBirth: json['date_of_birth'] as String?,
    photoUrl: json['photo_url'] as String?,
  );
}

Map<String, dynamic> _$PersonModelToJson(PersonModel instance) =>
    <String, dynamic>{
      'person_id': instance.personId,
      'name': instance.name,
      'weight': instance.weight,
      'height': instance.height,
      'date_of_birth': instance.dateOfBirth,
      'photo_url': instance.photoUrl,
    };
