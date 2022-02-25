import 'package:json_annotation/json_annotation.dart';

part 'image_upload_response.g.dart';

@JsonSerializable(createToJson: false)
class ImapeUploadResponse {
  final String? photoUrl;
  final String? newName;
  final int? size;
  final String? name;

  ImapeUploadResponse({
    this.photoUrl,
    this.newName,
    this.size,
    this.name,
  });

  factory ImapeUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$ImapeUploadResponseFromJson(json);
}
