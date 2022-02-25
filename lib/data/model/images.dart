import 'package:json_annotation/json_annotation.dart';

part 'images.g.dart';

@JsonSerializable()
class DeviceImage {
  int? imageId;
  bool? inbound;
  String? name;
  int? size;
  int? ts;

  DeviceImage({this.imageId, this.inbound, this.name, this.size, this.ts});

  Map<String, dynamic> toJson() => _$DeviceImageToJson(this);

  factory DeviceImage.fromJson(Map<String, dynamic> json) => _$DeviceImageFromJson(json);
}
