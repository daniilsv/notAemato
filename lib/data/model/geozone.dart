import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geozone.g.dart';

@JsonSerializable()
class GeozoneModel {
  @LatLngSerialiser()
  LatLng? center;
  String? name;
  int? id;
  String? type;
  int? radius;
  Map<String, dynamic>? props;

  GeozoneModel({this.center, this.name, this.id, this.type, this.radius, this.props});

  Map<String, dynamic> toJson() => _$GeozoneModelToJson(this);

  factory GeozoneModel.fromJson(Map<String, dynamic> json) =>
      _$GeozoneModelFromJson(json);
}

class LatLngSerialiser implements JsonConverter<LatLng?, Map<String, dynamic>?> {
  const LatLngSerialiser();

  @override
  LatLng? fromJson(Map<String, dynamic>? json) => json is Map<String, dynamic>
      ? LatLng(
          double.parse(json['lat']?.toString() ?? '0'),
          double.parse(json['lon']?.toString() ?? '0'),
        )
      : null;

  @override
  Map<String, dynamic>? toJson(LatLng? center) =>
      center is LatLng ? {'lat': center.latitude, 'lon': center.longitude} : null;
}
