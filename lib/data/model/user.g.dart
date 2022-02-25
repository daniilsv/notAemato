// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    skytag: json['skytag'] as String?,
    id: json['id'] as int?,
    photo: json['photo'] as String?,
    messageBadgeCounter: json['messageBadgeCounter'] as int?,
    eventBadgeCounter: json['eventBadgeCounter'] as int?,
    shareBadgeCounter: json['shareBadgeCounter'] as int?,
    photoBadgeCounter: json['photoBadgeCounter'] as int?,
    email: json['email'] as String?,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'skytag': instance.skytag,
      'id': instance.id,
      'photo': instance.photo,
      'messageBadgeCounter': instance.messageBadgeCounter,
      'eventBadgeCounter': instance.eventBadgeCounter,
      'shareBadgeCounter': instance.shareBadgeCounter,
      'photoBadgeCounter': instance.photoBadgeCounter,
      'email': instance.email,
    };
