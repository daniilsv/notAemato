import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/events.dart';
import 'package:notaemato/data/model/person.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/data/services/events.dart';
import 'package:notaemato/data/services/persons.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class EventsViewModel extends ReactiveViewModel {
  EventsViewModel(BuildContext context) {
    navigator = Navigator.of(context);
    rootNavigator = Navigator.of(context, rootNavigator: true);
  }
  @override
  List<ReactiveServiceMixin> get reactiveServices => [eventsService, personsService];
  // Services
  final api = locator<SocketApi>();
  final personsService = locator<PersonsService>();
  final devicesService = locator<DevicesService>();
  final eventsService = locator<EventsService>();
  List<Event> get events => eventsService.events;

  Map<int, PersonModel> get persons => personsService.persons;
  List<DeviceModel> get devices => devicesService.devices.val!;
  late NavigatorState navigator;
  late NavigatorState rootNavigator;
  // Constants

  // Controllers

  // Variables

  // Logic

  Future onReady() async {}

  PersonModel getPerson(DeviceModel device) {
    return persons[device.personId] != null
        ? persons[device.personId]!
        : PersonModel(name: 'Не привязано');
  }

  String getTitle(Event event) {
    if (event.event!.code == 100) return 'Опасное значение пульса';
    if (event.event!.code == 120) return 'Отправлен сигнал SOS';
    if (event.event!.code == 302) return 'Разряд батареи';
    if (event.event!.code == 1601) return 'Устройство снято';
    if (event.event!.code == 1701 && event.event!.q == 1)
      return 'Вход в геозону "${event.event!.geozoneName}"';
    if (event.event!.code == 1701 && event.event!.q == 3) return 'Выход из геозоны "${event.event!.geozoneName}"';
    if (event.event!.code == 1901) return 'Сервисное сообщение';
    if (event.event!.code == 2001) return 'Падение';
    if (event.event!.code == 2002) return 'Опасное значение давления';
    if (event.event!.code == 2003) return 'Измерение АД';
    if (event.event!.code == 2004) return 'Измерение пульса';
    if (event.event!.code == 2005) return 'Качество сна';
    if (event.event!.code == 2006) return 'Напоминание разминки';
    return event.event!.code.toString();
  }
}
