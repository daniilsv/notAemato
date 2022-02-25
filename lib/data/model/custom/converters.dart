import 'package:google_maps_flutter/google_maps_flutter.dart';

DateTime? convertDateFromJson(String? date) => DateTime.tryParse(date ?? '')?.toLocal();

LatLng convertLatLngFromJson(Map<String, dynamic>? jsonObject) =>
    jsonObject is Map<String, dynamic>
        ? LatLng(
            double.parse(jsonObject['lat']?.toString() ?? '0'),
            double.parse(jsonObject['lon']?.toString() ?? '0'),
          )
        : const LatLng(0, 0);

Map<String, dynamic> convertLatLngToJson(LatLng? center) =>
    center is LatLng ? {'lat': center.latitude, 'lon': center.longitude} : {};
