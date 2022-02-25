import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/geozone.dart';
import 'package:notaemato/data/services/geozones.dart';
import 'package:notaemato/data/services/markers.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';

class RadiusGeozoneViewModel extends BaseViewModel {
  RadiusGeozoneViewModel(BuildContext context) {
    navigator = Navigator.of(context);
    initial = ModalRoute.of(context)!.settings.arguments as GeozoneModel?;
    if (initial != null) {
      geozone = initial;
    }
  }
  // Services
  late NavigatorState navigator;
  final MarkersService _markersService = locator<MarkersService>();
  final SocketApi _api = locator<SocketApi>();
  final GeozonesService _geozonesService = locator<GeozonesService>();

  // Constants

  late GoogleMapController controller;
  final textController = TextEditingController();

  bool get isEdit => initial != null && initial!.name != null;
  bool get isNew => initial != null && initial!.name == null;

  LatLng initialPosition = const LatLng(0, 0);
  late LatLngBounds initialBounds;
  final markers = <Marker>{};
  Circle? circle;
  final circles = <Circle>{};
  double? radius;
  GeozoneModel? initial;
  GeozoneModel? geozone;
  bool enable = false;
  // Logic

  Future onReady() async {
    setBusy(true);
    if (geozone == null) {
      initialBounds = boundsFromLatLngList(
          _geozonesService.geozones.val!.map((e) => e.center).toList());
      initialPosition = LatLng(
          (initialBounds.northeast.latitude + initialBounds.southwest.latitude) / 2,
          (initialBounds.northeast.longitude + initialBounds.southwest.longitude) / 2);
      await update();
    }
    if (geozone != null) {
      if (geozone!.center == null) {
        final data = await Location().getLocation();
        final latlng = LatLng(data.latitude!, data.longitude!);
        geozone!.center = latlng;
        initialPosition = latlng;
      } else {
        initialPosition = geozone!.center!;
      }
      await update(geozone: geozone);
    }
    setBusy(false);
  }

  void setController(GoogleMapController controller) {
    this.controller = controller;
    if (initial == null)
      controller.animateCamera(CameraUpdate.newLatLngBounds(initialBounds, 100));
  }

  void setRadius(double newRadius) {
    geozone!.radius = newRadius.toInt();
    circles.clear();
    circles.add(Circle(
        circleId: CircleId('g${geozone!.id ?? 0}'),
        center: geozone!.center!,
        radius: newRadius,
        strokeWidth: 1,
        fillColor: AppColors.primary.withOpacity(0.2),
        strokeColor: AppColors.primary));
    notifyListeners();
  }

  void onMapTap(LatLng latlng) {
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: latlng, zoom: 16)),
    );
    geozone!.center = latlng;
    update(geozone: geozone);
    notifyListeners();
  }

  Future<void> update({GeozoneModel? geozone}) async {
    await _markersService.generateMarkers();
    markers.clear();
    circles.clear();
    if (initial == null) {
      for (final geozone in _geozonesService.geozones.val!) {
        circles.add(Circle(
            circleId: CircleId('g${geozone.id ?? 0}'),
            center: geozone.center!,
            radius: geozone.radius!.toDouble(),
            strokeWidth: 1,
            fillColor: AppColors.primary.withOpacity(0.2),
            strokeColor: AppColors.primary));
        markers.add(Marker(
          markerId: MarkerId('g${geozone.id}'),
          position: geozone.center!,
          icon: _markersService.bitmaps.value[null]!,
        ));
      }
    } else {
      circles.add(Circle(
          circleId: CircleId('g${geozone!.id ?? 0}'),
          center: geozone.center!,
          radius: geozone.radius!.toDouble(),
          strokeWidth: 1,
          fillColor: AppColors.primary.withOpacity(0.2),
          strokeColor: AppColors.primary));
      markers.add(Marker(
        markerId: MarkerId('g${geozone.id ?? 0}'),
        position: geozone.center!,
        icon: _markersService.bitmaps.value[null]!,
      ));
    }
    notifyListeners();
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

  void onChanged() {
    if (textController.text.isNotEmpty)
      enable = true;
    else
      enable = false;
    notifyListeners();
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

//TODO: check this
  Future<void> onSaveTap() async {
    geozone!.name = textController.text;
    setBusy(true);
    await _api.upsertGeozone(geozone!);
    await _geozonesService.update(force: true);
    navigator.pop();
  }

  Future<void> onPop() async {
    if (isEdit) {
      setBusy(true);
      await _api.upsertGeozone(geozone!);
      await _geozonesService.update(force: true);
      navigator.pop(geozone);
    } else {
      navigator.pop();
    }
  }
}
