// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_access_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonAccessRequest _$PersonAccessRequestFromJson(Map<String, dynamic> json) {
  return PersonAccessRequest(
    userName: json['user_name'] as String?,
    email: json['email'] as String?,
    userPhotoUrl: json['user_photo'] as String?,
    personPhotoUrl: json['person_profile_photo'] as String?,
    phone: json['phone'] as String?,
    roleTitle: json['role_title'] as String?,
    personId: json['person_id'] as int?,
    personAccessId: json['person_access_id'] as int?,
    isAccepted: _$enumDecodeNullable(_$IsAcceptedEnumMap, json['is_accepted']),
    isInvite: json['is_invite'] as bool?,
  );
}

Map<String, dynamic> _$PersonAccessRequestToJson(
        PersonAccessRequest instance) =>
    <String, dynamic>{
      'user_name': instance.userName,
      'email': instance.email,
      'user_photo': instance.userPhotoUrl,
      'person_profile_photo': instance.personPhotoUrl,
      'phone': instance.phone,
      'role_title': instance.roleTitle,
      'person_id': instance.personId,
      'person_access_id': instance.personAccessId,
      'is_accepted': _$IsAcceptedEnumMap[instance.isAccepted],
      'is_invite': instance.isInvite,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$IsAcceptedEnumMap = {
  IsAccepted.active: 'active',
  IsAccepted.declined: 'declined',
  IsAccepted.waiting: 'waiting',
};
