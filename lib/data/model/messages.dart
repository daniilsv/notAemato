import 'package:json_annotation/json_annotation.dart';

part 'messages.g.dart';

@JsonSerializable()
class MessageModel {
  int? mailId;
  bool? inbound;
  int? duration;
  String? text;
  int? ts;

  MessageModel({this.mailId, this.inbound, this.duration, this.text, this.ts});

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

class MessageData {
  MessageModel? message;
  String? data;

  MessageData({this.message, this.data});
}
