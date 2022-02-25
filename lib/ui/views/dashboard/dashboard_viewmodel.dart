import 'dart:async';

import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/person.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/data/services/persons.dart';
import 'package:notaemato/ui/views/add_device/add_device_view.dart';
import 'package:notaemato/ui/views/device/device_view.dart';
import 'package:notaemato/ui/views/devices_map/devices_map_view.dart';
import 'package:notaemato/ui/views/person_selection/person_selection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class DashboardViewModel extends ReactiveViewModel {
  DashboardViewModel(BuildContext context) {
    navigator = Navigator.of(context);
    rootNavigator = Navigator.of(context, rootNavigator: true);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [devicesService, personsService];
  // Services
  final DevicesService devicesService = locator<DevicesService>();
  final SocketApi api = locator<SocketApi>();
  final PersonsService personsService = locator<PersonsService>();
  late final NavigatorState navigator;
  late final NavigatorState rootNavigator;
  List<DeviceModel> get devices => devicesService.devices.val!;
  Map<int, PersonModel> get persons => personsService.persons;

  List<String> adresses = [];
  String? mapStyle;
  PersonModel tempPerson = PersonModel(name: 'Не привязано', personId: 0);

  // Constants

  // Controllers

  // Variables

  // Logic

  Future onReady() async {
  }

  void onAddDeviceTap() {
    rootNavigator.push(AddDeviceViewRoute());
  }

  // Future<void> getLastAdresses(List<DeviceModel> devices) async {
  //   for (final dev in devices) {
  //     final coordinates = Coordinates(
  //         dev.lat != 0 ? dev.lat.toDouble() : 52.3566875455577, //TODO this test
  //         dev.lon != 0 ? dev.lon.toDouble() : 106.1005018051097);
  //     final addres = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //     adresses.add(addres.first.addressLine ?? 'Неизвестно');
  //   }
  //   notifyListeners();
  // }

  Future<void> onDeviceTap(DeviceModel device) async {
    final ret = await navigator.push(DeviceViewRoute(device));
    if (ret == null) return;
  }

  Future<void> onAddPersonTap(DeviceModel device) async {
    final ret = await rootNavigator.push(PersonSelectionViewRoute(device));
    if (ret == null) return;
  }

  Future<void> onMapTap() async {
    MetricaService.event('map_open');
    rootNavigator.push(DevicesMapViewRoute());
  }

  // Future<void> getMapStyle() async {
  //   mapStyle = await rootBundle.loadString('assets/map/style.json');
  //   notifyListeners();
  // }
}
