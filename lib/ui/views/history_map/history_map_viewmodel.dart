import 'package:notaemato/data/model/history.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';

class HistoryMapViewModel extends BaseViewModel {
  HistoryMapViewModel(BuildContext context) {
    navigator = Navigator.of(context);
    points = ModalRoute.of(context)!.settings.arguments as List<HistoryPoint>?;
    initialBounds =
        boundsFromLatLngList(points!.map((e) => LatLng(e.lat!, e.lon!)).toList());
    initialPosition = LatLng(
        (initialBounds.northeast.latitude + initialBounds.southwest.latitude) / 2,
        (initialBounds.northeast.longitude + initialBounds.southwest.longitude) / 2);
  }
  // Services
  late NavigatorState navigator;
  late List<HistoryPoint>? points;

  // Constants

  late GoogleMapController controller;

  LatLng initialPosition = const LatLng(0, 0);
  late LatLngBounds initialBounds;
  final polylines = <Polyline>{};
  String get date => Jiffy.unix(points!.first.ts!).MMMEd;

  // Logic

  Future onReady() async {
    setBusy(true);
    polylines.add(Polyline(
        polylineId: PolylineId('1'),
        color: AppColors.primary,
        width: 4,
        points: points!.map((e) => LatLng(e.lat!, e.lon!)).toList(),
        zIndex: 5));
    setBusy(false);
    notifyListeners();
  }

  void setController(GoogleMapController controller) {
    this.controller = controller;
    controller.animateCamera(CameraUpdate.newLatLngBounds(initialBounds, 50));
  }

  int getSteps() {
    var sum = 0;
    for (var i = 0; i < points!.length; i++) {
      sum += points![i].stepCount!;
    }
    return sum.toInt();
  }

  static LatLngBounds boundsFromLatLngList(List<LatLng?> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (final latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng!.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng!.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(southwest: LatLng(x0!, y0!), northeast: LatLng(x1!, y1!));
  }

  Future<void> animateSelf() async {
    final _location = Location();
    final _current = await Future.any<LocationData>([
      _location.getLocation(),
      Future<LocationData>.delayed(const Duration(seconds: 1)),
    ]);
    if (_current is! LocationData) return;
    final pos = CameraPosition(
      target: LatLng(_current.latitude!, _current.longitude!),
      zoom: 16,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(pos));
  }

  Future<void> onPop() async {
    controller.dispose();

    navigator.pop();
  }
}
