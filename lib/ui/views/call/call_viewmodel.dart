import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/data/services/janus.dart';
import 'package:notaemato/data/services/persons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/src/rtc_video_renderer.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class CallViewModel extends ReactiveViewModel {
  CallViewModel(BuildContext context) {
    navigator = Navigator.of(context);
  }
  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [janusService, devicesService, personsService];
  // Services
  final janusService = locator<JanusService>();
  final devicesService = locator<DevicesService>();
  final personsService = locator<PersonsService>();
  late NavigatorState navigator;

  CallingState get state => janusService.state.value;

  String get personName => 'Маша';

  bool isRenderersSwitched = false;
  bool get mirror => janusService.mirror;
  bool speakers = false;
  bool mute = false;
  bool camera = true;

  RTCVideoRenderer get localRenderer => janusService.localRenderer!;
  RTCVideoRenderer get firstRenderer =>
      !isRenderersSwitched ? janusService.remoteRenderer! : janusService.localRenderer!;
  RTCVideoRenderer get secondRenderer =>
      !isRenderersSwitched ? janusService.localRenderer! : janusService.remoteRenderer!;

  String get time => DateFormat.ms().format(
        DateTime(0, 0, 0, 0, 0, janusService.duration.value),
      );

  void switchRenderers() {
    isRenderersSwitched = !isRenderersSwitched;
    notifyListeners();
  }

  void answer() => janusService.answer();

  void decline() => janusService.decline();

  void flipCamera() {
    janusService.flipCamera();
    notifyListeners();
  }

  void toggleMute() {
    mute = !mute;
    notifyListeners();
    janusService.setMute(mute);
  }

  void toggleSpeaker() {
    speakers = !speakers;
    notifyListeners();
    janusService.setSpeaker(speakers);
  }

  void toggleNoCamera() {
    camera = !camera;
    notifyListeners();
    janusService.setCamera(camera);
  }

  Future<bool> onWillPop() async {
    janusService.hangup();
    return false;
  }
}
