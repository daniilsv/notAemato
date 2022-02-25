import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/geozone.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/data/services/geozones.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import 'views/geozone_view.dart';
import 'views/geozones_map_view.dart';

class GeozonesViewModel extends ReactiveViewModel {
  GeozonesViewModel(BuildContext context) {
    device = ModalRoute.of(context)!.settings.arguments as DeviceModel?;
    navigator = Navigator.of(context);
    rootNavigator = Navigator.of(context, rootNavigator: true);
  }
  @override
  List<ReactiveServiceMixin> get reactiveServices => [devicesService, geozonesService];
  // Services
  final SocketApi api = locator<SocketApi>();
  final DevicesService devicesService = locator<DevicesService>();
  final GeozonesService geozonesService = locator<GeozonesService>();
  late NavigatorState navigator;
  late NavigatorState rootNavigator;

  // Constants
  DeviceModel? device;
  List<GeozoneModel> get geozones => geozonesService.geozones.val!;

  // Controllers

  // Variables

  // Logic

  Future<void> onMapTap() async {
    MetricaService.event('geozone_menu_tap');
    rootNavigator.push(GeozonesMapViewRoute());
  }

  Future<void> onAddGeozoneTap() async {
    MetricaService.event('geozone_add_tap');
    rootNavigator.push(GeozonesMapViewRoute(geozone: GeozoneModel(radius: 150)));
  }

  Future<void> onGeozoneTap(GeozoneModel geo) async {
    MetricaService.event('geozone_tap', {'geozone': geo.id});
    navigator.push(GeozoneViewRoute(geozone: geo));
  }

  Future onReady() async {
    setBusy(true);
    geozonesService.update(force: true);
    setBusy(false);
  }
}
