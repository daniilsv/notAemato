import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable()
class PersonModel {
  @JsonKey(name: 'person_id')
  int? personId;
  String? name;
  int? weight;
  int? height;
  @JsonKey(name: 'date_of_birth')
  String? dateOfBirth;
  @JsonKey(name: 'photo_url')
  String? photoUrl;

  PersonModel(
      {this.personId,
      this.name,
      this.weight,
      this.height,
      this.dateOfBirth,
      this.photoUrl});

  Map<String, dynamic> toJson() => _$PersonModelToJson(this);

  factory PersonModel.fromJson(Map<String, dynamic> json) => _$PersonModelFromJson(json);
}
