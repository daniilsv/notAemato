import 'package:json_annotation/json_annotation.dart';

import 'device.dart';

part 'objects.g.dart';

@JsonSerializable()
class ObjectsModel {
  List<DeviceModel>? objects;
  List<int>? my;
  // List<Object> friends;
  // List<Object> hubs;
  ObjectsModel();

  Map<String, dynamic> toJson() => _$ObjectsModelToJson(this);

  factory ObjectsModel.fromJson(Map<String, dynamic> json) =>
      _$ObjectsModelFromJson(json);
}
