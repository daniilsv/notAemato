// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return MessageModel(
    mailId: json['mailId'] as int?,
    inbound: json['inbound'] as bool?,
    duration: json['duration'] as int?,
    text: json['text'] as String?,
    ts: json['ts'] as int?,
  );
}

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'mailId': instance.mailId,
      'inbound': instance.inbound,
      'duration': instance.duration,
      'text': instance.text,
      'ts': instance.ts,
    };
