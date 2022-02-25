import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/dto/socket_error.dart';
import 'package:notaemato/data/model/messages.dart';
import 'package:notaemato/data/model/person.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/data/services/janus.dart';
import 'package:notaemato/data/services/messages.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/data/services/persons.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/widgets/app_dialog.dart';
import 'package:notaemato/ui/widgets/switch_error.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatViewModel extends ReactiveViewModel {
  ChatViewModel(BuildContext context) {
    navigator = Navigator.of(context);
    rootNavigator = Navigator.of(context, rootNavigator: true);
    device = ModalRoute.of(context)!.settings.arguments! as DeviceModel;
    person = persons[device.personId];
  }
  @override
  List<ReactiveServiceMixin> get reactiveServices => [messagesService];
  // Services
  late final SocketApi api = locator<SocketApi>();
  late final PersonsService personsService = locator<PersonsService>();
  late final DevicesService devicesService = locator<DevicesService>();
  late final MessagesService messagesService = locator<MessagesService>();
  List<MessageModel> get messages => messagesService.messages[device] ?? [];
  Map<int, PersonModel> get persons => personsService.persons;
  List<DeviceModel> get devices => devicesService.devices.val!;
  BuildContext? context;
  NavigatorState? navigator;
  NavigatorState? rootNavigator;
  late DeviceModel device;
  late PersonModel? person;
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('audio-message');

  // Constants

  // Controllers
  final FocusNode inputFocusNode = FocusNode();
  ScrollController? controller;

  // Variables

  // Logic

  Future onReady() async {
    MetricaService.event('chat_open', {'oid': device.oid});
    messagesService.updateByDevice(device, ping: true);
  }

  @override
  void dispose() {
    try {
      audioPlayer.dispose();
    } on Object {}
    super.dispose();
  }

  Future<void> send(String text) async {
    try {
      final message = await api.sendTextMessageToObject(device.oid, text);
      logger.i(message);
      messagesService.addMessage(device.oid, message);
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        // проверьте интернет
        final retry = await showAppDialog(
          title: Strings.current.error,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == true) send(text);
        return;
      }
      switchError(e.error);
    } finally {}
    notifyListeners();
  }

  String getAudio(int id) {
    return '${messagesService.dir}/$id.mp3';
  }

  Future<void> sendAudio(String base64, int duration) async {
    try {
      final message = await api.sendAudioMessageToObject(device.oid, base64);
      logger.i(message);
      messagesService.addMessage(device.oid, message);
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        // проверьте интернет
        final retry = await showAppDialog(
          title: Strings.current.error,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == true) sendAudio(base64, duration);
        return;
      }
      switchError(e.error);
    } finally {}
    notifyListeners();
  }

  Future<void> onVideoCallTap() async {
    setBusy(true);
    try {
      MetricaService.event('device_video_tap', {'oid': device.oid});
      final call = await api.createVideocall(device.oid);
      final janus = locator<JanusService>();
      await janus.initClient(
        call!.data!.janus!.hostname!,
        call.data!.janus!.token!,
        call.caller!.uid!,
      );
      await janus.makeCall(call.callee!.uid!);
    } on Object catch (e) {
      showAppDialog(
        subtitle: e.toString(),
      );
    }
    setBusy(false);
  }

  Future<void> onCallTap() async {
    launch('tel://${device.deviceProps!.simNumber1}');
  }
}
