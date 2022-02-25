import 'package:notaemato/data/model/device.dart';
import 'package:jiffy/jiffy.dart';
import 'package:json_annotation/json_annotation.dart';

part 'events.g.dart';

@JsonSerializable()
class EventModel {
  int? id;
  int? code;
  int? q;
  int? deviceTs;
  @JsonKey(fromJson: jiffyFromAny, toJson: jiffyToInt)
  Jiffy? ts;
  int? geozoneId;
  String? geozoneName;
  @JsonKey(fromJson: numOrString, toJson: anyToDouble)
  double? lat;
  @JsonKey(fromJson: numOrString, toJson: anyToDouble)
  double? lon;
  // @EventsSerialiser()
  // Map<String, dynamic>? message;

  EventModel({
    this.id,
    this.code,
    this.q,
    this.deviceTs,
    this.ts,
    this.geozoneId,
    this.geozoneName,
    this.lat,
    this.lon,
    // this.message,
  });
  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  factory EventModel.fromJson(Map<String, dynamic> json) => _$EventModelFromJson(json);
}

int? jiffyToInt(Jiffy? obj) {
  if (obj == null) return null;
  return obj.dateTime.millisecondsSinceEpoch ~/ 1000;
}

Jiffy? jiffyFromAny(dynamic obj) {
  if (obj == null) return null;
  if (obj is int) return Jiffy(DateTime.fromMillisecondsSinceEpoch(obj * 1000));
  return Jiffy(obj);
}

double? numOrString(Object? obj) {
  if (obj == null) return null;
  if (obj is num) return obj.toDouble();
  return double.tryParse(obj.toString());
}

double? anyToDouble(Object? obj) {
  if (obj == null) return null;
  if (obj is num) return obj.toDouble();
  return double.tryParse(obj.toString());
}

class Event {
  DeviceModel? device;
  EventModel? event;

  Event({this.device, this.event});
}

// class EventsSerialiser implements JsonConverter<Map<String, dynamic>?, String?> {
//   const EventsSerialiser();

//   @override
//   Map<String, dynamic> fromJson(String? json) =>
//       json == null ? {} : Map.from(jsonDecode(json));

//   @override
//   String toJson(Map<String, dynamic>? message) => jsonEncode(message);
// }
