import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/messages.dart';
import 'package:notaemato/data/model/person.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/data/services/messages.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/data/services/persons.dart';
import 'package:notaemato/ui/views/chat/chat_view.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';

class MessagesViewModel extends ReactiveViewModel {
  MessagesViewModel(BuildContext context) {
    navigator = Navigator.of(context);
    rootNavigator = Navigator.of(context, rootNavigator: true);
  }
  @override
  List<ReactiveServiceMixin> get reactiveServices => [messagesService];
  // Services
  final SocketApi api = locator<SocketApi>();
  final PersonsService personsService = locator<PersonsService>();
  final DevicesService devicesService = locator<DevicesService>();
  final MessagesService messagesService = locator<MessagesService>();
  Map<DeviceModel, List<MessageModel>> get messages => messagesService.messages;
  Map<int, PersonModel> get persons => personsService.persons;
  List<DeviceModel> get devices => devicesService.devices.val!;
  BuildContext? context;
  late NavigatorState navigator;
  NavigatorState? rootNavigator;

  // Constants

  // Controllers

  // Variables

  // Logic

  Future onReady() async {
    //
  }

  Future onPersonTap(DeviceModel device) async {
    MetricaService.event('messages_person_tap', {'oid': device.oid});
    await navigator.push(ChatViewRoute(device: device));
    notifyListeners();
  }

  DateTime? getLastMessageDate(MessageModel? m) {
    return m == null ? null : Jiffy.unix(m.ts!).dateTime;
  }

  String? getLastMessageString(MessageModel? m) {
    if (m == null) return 'Cообщений нет';
    if (m.text == null) return 'Голосовое сообщение';
    return m.text;
  }
}
