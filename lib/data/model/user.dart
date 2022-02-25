import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel extends Equatable{
  final String? skytag;
  final int? id;
  final String? photo;
  final int? messageBadgeCounter;
  final int? eventBadgeCounter;
  final int? shareBadgeCounter;
  final int? photoBadgeCounter;
  final String? email;
  // final String __connection;

  const UserModel({
    this.skytag,
    this.id,
    this.photo,
    this.messageBadgeCounter,
    this.eventBadgeCounter,
    this.shareBadgeCounter,
    this.photoBadgeCounter,
    this.email,
  });

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  @override
  List<Object?> get props => [email];
}
