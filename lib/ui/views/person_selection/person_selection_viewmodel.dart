import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/person.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/data/services/persons.dart';
import 'package:notaemato/ui/views/person/person_view.dart';
import 'package:notaemato/ui/views/person_selection/views/shift_devices_view.dart';
import 'package:notaemato/ui/views/trusted_numbers/trusted_numbers_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import 'views/complete.dart';

class PersonSelectionViewModel extends ReactiveViewModel {
  PersonSelectionViewModel(this.context) {
    navigator = Navigator.of(context);
    rootNavigator = Navigator.of(context, rootNavigator: true);
    device = ModalRoute.of(context)!.settings.arguments as DeviceModel? ?? devices.first;
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [devicesService, personsService];
  // Services
  final SocketApi api = locator<SocketApi>();
  final PersonsService personsService = locator<PersonsService>();
  final DevicesService devicesService = locator<DevicesService>();
  BuildContext context;
  late NavigatorState navigator;
  NavigatorState? rootNavigator;

  // Constants

  // Controllers
  final trustedNumbersController = TextEditingController();
  final phoneController = TextEditingController();

  // Variables
  DeviceModel? initial;
  late DeviceModel device;
  List<DeviceModel> get devices => devicesService.devices.val!;
  List<PersonModel> get persons => personsService.rawPersons.value.val!;
  int selectedPerson = 0;
  List<PhonebookPhone>? get phonebook => device.deviceProps!.phonebook;

  // Logic
  DateTime get lastActiveTime => DateTime.fromMillisecondsSinceEpoch(device.states?.coordTs ?? 0);

  Future onReady() async {
    await devicesService.update(force: true);
    trustedNumbersController.text =
        '${device.deviceProps!.phonebook!.length} ${getStringForNumbersLength(device.deviceProps!.phonebook!.length)}';
  }

  String getStringForNumbersLength(int length) {
    String text;
    final last = int.parse(length.toString().characters.last);
    if (last == 1) {
      text = 'доверенный номер';
    } else if ([2, 3, 4].any((element) => element == last)) {
      text = 'доверенных номера';
    } else {
      text = 'доверенных номеров';
    }
    return text;
  }

  Future onTrustedNumbersTap() async {
    final phonebook = await navigator.push(TrustedNumbersViewRoute(device));
    if (phonebook == null) return;
    trustedNumbersController.text =
        '${phonebook.length.toString()} ${getStringForNumbersLength(phonebook.length)}';
    notifyListeners();
  }

  Future<void> onAddPersonTap() async {
    await navigator.push(PersonViewRoute());
    selectedPerson = persons.length;
    notifyListeners();
  }

  Future<bool> onWillPop() async {
    if (device.personId != null) return true;
    return false;
  }

  DeviceModel? getPersonDevice(int? id) {
    if (devices.any((element) => element.personId == id))
      return devices.firstWhere((element) => element.personId == id);
    return null;
  }

  void setPerson(int index) {
    selectedPerson = index;
    notifyListeners();
  }

  Future<void> save() async {
    MetricaService.event('person_select_save', {'oid': device.oid});
    setBusy(true);
    if (phoneController.text.isNotEmpty) {
      final ret2 = await api.changeObjectCard(device.oid, phoneController.text);
      logger.i(ret2);
    }
    if (devices.any((element) => element.personId == persons[selectedPerson].personId)) {
      final map = {
        persons[selectedPerson]: devices.firstWhere(
            (element) => element.personId == persons[selectedPerson].personId),
        persons[selectedPerson]: device
      };
      MetricaService.event('device_shift', {'oid': device.oid});
      navigator.push(ShiftDevicesViewRoute(map));
      setBusy(false);
      return;
    }
    final ret = await api.setObjectProfile(device.oid, persons[selectedPerson].personId);
    logger.i(ret);
    if (ret != null) {
      await devicesService.update(force: true);
      setBusy(false);
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (_) => AddPersonCompleteView(name: persons[selectedPerson].name),
        ),
      );
    }
    setBusy(false);
  }
}
