// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videocall.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideocallResponseModel _$VideocallResponseModelFromJson(
    Map<String, dynamic> json) {
  return VideocallResponseModel(
    uid: json['uid'] as String?,
    createdAt: json['createdAt'] as String?,
    caller: json['caller'] == null
        ? null
        : VideocallCaller.fromJson(json['caller'] as Map<String, dynamic>),
    callee: json['callee'] == null
        ? null
        : VideocallCallee.fromJson(json['callee'] as Map<String, dynamic>),
    data: json['data'] == null
        ? null
        : VideocallData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VideocallResponseModelToJson(
        VideocallResponseModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'createdAt': instance.createdAt,
      'caller': instance.caller,
      'callee': instance.callee,
      'data': instance.data,
    };

VideocallCaller _$VideocallCallerFromJson(Map<String, dynamic> json) {
  return VideocallCaller(
    type: json['type'] as String?,
    profileId: json['profileId'] as String?,
    uid: json['uid'] as String?,
  );
}

Map<String, dynamic> _$VideocallCallerToJson(VideocallCaller instance) =>
    <String, dynamic>{
      'type': instance.type,
      'profileId': instance.profileId,
      'uid': instance.uid,
    };

VideocallCallee _$VideocallCalleeFromJson(Map<String, dynamic> json) {
  return VideocallCallee(
    type: json['type'] as String?,
    deviceId: json['deviceId'] as String?,
    uid: json['uid'] as String?,
  );
}

Map<String, dynamic> _$VideocallCalleeToJson(VideocallCallee instance) =>
    <String, dynamic>{
      'type': instance.type,
      'deviceId': instance.deviceId,
      'uid': instance.uid,
    };

VideocallData _$VideocallDataFromJson(Map<String, dynamic> json) {
  return VideocallData(
    janus: json['janus'] == null
        ? null
        : JanusHost.fromJson(json['janus'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VideocallDataToJson(VideocallData instance) =>
    <String, dynamic>{
      'janus': instance.janus,
    };

JanusHost _$JanusHostFromJson(Map<String, dynamic> json) {
  return JanusHost(
    hostname: json['hostname'] as String?,
    token: json['token'] as String?,
  );
}

Map<String, dynamic> _$JanusHostToJson(JanusHost instance) => <String, dynamic>{
      'hostname': instance.hostname,
      'token': instance.token,
    };
