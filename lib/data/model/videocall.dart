import 'package:json_annotation/json_annotation.dart';

part 'videocall.g.dart';

@JsonSerializable()
class VideocallResponseModel {
  String? uid;
  String? createdAt;
  VideocallCaller? caller;
  VideocallCallee? callee;
  VideocallData? data;

  VideocallResponseModel({this.uid, this.createdAt, this.caller, this.callee, this.data});

  Map<String, dynamic> toJson() => _$VideocallResponseModelToJson(this);

  factory VideocallResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VideocallResponseModelFromJson(json);
}

@JsonSerializable()
class VideocallCaller {
  String? type;
  String? profileId;
  String? uid;

  VideocallCaller({this.type, this.profileId, this.uid});

  Map<String, dynamic> toJson() => _$VideocallCallerToJson(this);

  factory VideocallCaller.fromJson(Map<String, dynamic> json) =>
      _$VideocallCallerFromJson(json);
}

@JsonSerializable()
class VideocallCallee {
  String? type;
  String? deviceId;
  String? uid;

  VideocallCallee({this.type, this.deviceId, this.uid});

  Map<String, dynamic> toJson() => _$VideocallCalleeToJson(this);

  factory VideocallCallee.fromJson(Map<String, dynamic> json) =>
      _$VideocallCalleeFromJson(json);
}

@JsonSerializable()
class VideocallData {
  JanusHost? janus;

  VideocallData({this.janus});

  Map<String, dynamic> toJson() => _$VideocallDataToJson(this);

  factory VideocallData.fromJson(Map<String, dynamic> json) =>
      _$VideocallDataFromJson(json);
}

@JsonSerializable()
class JanusHost {
  String? hostname;
  String? token;

  JanusHost({this.hostname, this.token});

  Map<String, dynamic> toJson() => _$JanusHostToJson(this);

  factory JanusHost.fromJson(Map<String, dynamic> json) => _$JanusHostFromJson(json);
}
