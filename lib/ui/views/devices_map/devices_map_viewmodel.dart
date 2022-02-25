import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/data/services/markers.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/data/services/persons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:stacked/stacked.dart';

class DevicesMapViewModel extends ReactiveViewModel {
  DevicesMapViewModel();

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_markersService, _devicesService, _personsService];
  // Services
  final MarkersService _markersService = locator<MarkersService>();
  final DevicesService _devicesService = locator<DevicesService>();
  final PersonsService _personsService = locator<PersonsService>();

  // Constants

  // Controllers

  // Variables
  List<DeviceModel> get devices => _devicesService.devices.val!;

  late GoogleMapController controller;

  late LatLng initialPosition;
  late LatLngBounds initialBounds;
  final markers = <Marker>{};
  // Logic

  Future onReady() async {
    setBusy(true);
    initialBounds = boundsFromLatLngList(devices.map((e) => e.location).toList());
    initialPosition = LatLng(
        (initialBounds.northeast.latitude + initialBounds.southwest.latitude) / 2,
        (initialBounds.northeast.longitude + initialBounds.southwest.longitude) / 2);
    await update();
    setBusy(false);
  }

  Future<void> update() async {
    await _markersService.generateMarkers();
    markers.clear();
    for (final device in devices) {
      final person = _personsService.persons[device.personId];
      final icon = _markersService.bitmaps.value[person?.photoUrl] ??
          _markersService.bitmaps.value[null]!;
      markers.add(Marker(
        markerId: MarkerId('d${device.oid}'),
        position: device.location,
        icon: icon,
        onTap: () {
          MetricaService.event('map_marker_tap', {'oid': device.oid});
        },
      ));
    }
    notifyListeners();
  }

  static LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (final latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(southwest: LatLng(x0!, y0!), northeast: LatLng(x1!, y1!));
  }

  void setController(GoogleMapController controller) {
    this.controller = controller;
    controller.animateCamera(CameraUpdate.newLatLngBounds(initialBounds, 16));
  }

  Future<void> animateSelf() async {
    MetricaService.event('map_self_tap');
    final _location = Location();
    final _current = await Future.any<LocationData>([
      _location.getLocation(),
      Future<LocationData>.delayed(const Duration(seconds: 1)),
    ]);
    if (_current is! LocationData) return;
    final pos = CameraPosition(
      target: LatLng(_current.latitude!, _current.longitude!),
      zoom: 14,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(pos));
  }
}
