import 'package:json_annotation/json_annotation.dart';

import 'enum/is_accepted.dart';

part 'person_access_request.g.dart';

@JsonSerializable()
class PersonAccessRequest {
  @JsonKey(name: 'user_name')
  String? userName;
  String? email;
  @JsonKey(name: 'user_photo')
  String? userPhotoUrl;
  @JsonKey(name: 'person_profile_photo')
  String? personPhotoUrl;
  String? phone;
  @JsonKey(name: 'role_title')
  String? roleTitle;
  @JsonKey(name: 'person_id')
  int? personId;
  @JsonKey(name: 'person_access_id')
  int? personAccessId;
  @JsonKey(name: 'is_accepted')
  IsAccepted? isAccepted;
  @JsonKey(name: 'is_invite')
  bool? isInvite;

  PersonAccessRequest(
      {this.userName,
      this.email,
      this.userPhotoUrl,
      this.personPhotoUrl,
      this.phone,
      this.roleTitle,
      this.personId,
      this.personAccessId,
      this.isAccepted,
      this.isInvite});

  Map<String, dynamic> toJson() => _$PersonAccessRequestToJson(this);

  factory PersonAccessRequest.fromJson(Map<String, dynamic> json) =>
      _$PersonAccessRequestFromJson(json);
}
