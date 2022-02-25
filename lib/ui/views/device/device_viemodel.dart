import 'dart:math';

import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/activity.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/dto/socket_error.dart';
import 'package:notaemato/data/model/geozone.dart';
import 'package:notaemato/data/model/person.dart';
import 'package:notaemato/data/model/pulse.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/data/services/geozones.dart';
import 'package:notaemato/data/services/janus.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/data/services/navigator.dart';
import 'package:notaemato/data/services/persons.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/views/alarm_clocks/alarm_clocks_view.dart';
import 'package:notaemato/ui/views/back_call/back_call_view.dart';
import 'package:notaemato/ui/views/chat/chat_view.dart';
import 'package:notaemato/ui/views/device/views/health_view.dart';
import 'package:notaemato/ui/views/device_map/device_map_view.dart';
import 'package:notaemato/ui/views/dnd/dnd_view.dart';
import 'package:notaemato/ui/views/gallery/gallery_view.dart';
import 'package:notaemato/ui/views/geozones/geozones_view.dart';
import 'package:notaemato/ui/views/history_displacements/history_displacements_view.dart';
import 'package:notaemato/ui/views/settings/settings_view.dart';
import 'package:notaemato/ui/widgets/app_dialog.dart';
import 'package:notaemato/ui/widgets/switch_error.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class DeviceViewModel extends ReactiveViewModel {
  DeviceViewModel(BuildContext context) {
    initial = ModalRoute.of(context)!.settings.arguments as DeviceModel?;
    navigator = Navigator.of(context);
    rootNavigator = Navigator.of(context, rootNavigator: true);
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(navigator.context).padding.bottom),
        axis: Axis.vertical);
  }
  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [devicesService, personsService, geozonesService];
  // Services
  final SocketApi api = locator<SocketApi>();
  final DevicesService devicesService = locator<DevicesService>();
  final PersonsService personsService = locator<PersonsService>();
  final GeozonesService geozonesService = locator<GeozonesService>();
  late NavigatorState navigator;
  late NavigatorState rootNavigator;

  // Constants
  int get maxPulse => pulse != null && pulse!.days!.first.measurements!.isNotEmpty
      ? pulse?.days?.first.measurements?.map((e) => e.pulse ?? 0).reduce(max).abs() ?? 0
      : 0;

  // Controllers

  // Variables
  PersonModel? get person => personsService.persons[device.personId];
  DeviceModel? initial;
  DeviceModel get device =>
      devicesService.devices.val!.firstWhere((element) => element == initial);
  String? adress;
  ActivityModel? activity;
  PulseModel? pulse;
  List<GeozoneModel>? get geozones => geozonesService.geozones.val;
  late AutoScrollController controller;

  // String mapStyle;

  // Logic

  Future onReady() async {
    MetricaService.event('device_open', {'oid': device.oid});
    getActivityHistory();
    getPulseHistory();
  }

  Future<void> getActivityHistory() async {
    activity = await api.getActivityHistory(device.oid, DateTime.now(), 1);
    notifyListeners();
  }

  Future<void> getPulseHistory() async {
    pulse = await api.getPulseHistory(device.oid, DateTime.now(), 1);
    notifyListeners();
  }

  Future<void> onMoreTap() async {
    MetricaService.event('device_more_tap', {'oid': device.oid});
    await controller.scrollToIndex(
      3,
      preferPosition: AutoScrollPosition.middle,
      duration: const Duration(seconds: 1),
    );
  }

  Future<void> onPhoneCallTap() async {
    MetricaService.event('device_phone_call', {'oid': device.oid});
    launch('tel://${device.deviceProps!.simNumber1}');
  }

  Future<void> onMessageTap() async {
    MetricaService.event('device_message_tap', {'oid': device.oid});
    locator<NavigatorService>().changePage(1);
    locator<NavigatorService>().navigatorKeys[1].currentState
      ?..popUntil((route) => route.isFirst)
      ..push(ChatViewRoute(device: device));
  }

  // Future<void> onShare() async {
  //   MetricaService.event('device_share_tap', {'oid': device.oid});
  //   Share.share(
  //     '${person!.name} сейчас находится здесь - https://www.google.com/maps/search/?api=1&query=${device.lat},${device.lon}&zoom=18',
  //     subject: 'Местоположение персоны ${person!.name}',
  //   );
  // }

  Future<void> onRefresh() async {
    MetricaService.event('device_refresh_tap', {'oid': device.oid});
    setBusy(true);

    try {
      final ret = await api.clarifyObjectLocation(device.oid);
      logger.i(ret);
      // if (ret == 0) {
      //   showAppDialog(
      //       title: 'Ожидайте сигнала с устройства', subtitle: 'Запрос отправлен');
      // }
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        // проверьте интернет
        final retry = await showAppDialog(
          title: Strings.current.error,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == true) onTakePhotoTap();
        return;
      }
      switchError(e.error);
    } finally {
      await devicesService.update(force: true);
      setBusy(false);
    }
    notifyListeners();
  }

  Future<void> onMap() async {
    MetricaService.event('device_map_tap', {'oid': device.oid});
    await rootNavigator.push(DeviceMapViewRoute(device));
    devicesService.update(force: true);
  }

  Future<void> onVideoCallTap() async {
    setBusy(true);
    try {
      MetricaService.event('device_video_tap', {'oid': device.oid});
      final call = await api.createVideocall(device.oid);
      Logger().wtf(call);
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
    // //? test here: https://janus.conf.meetecho.com/videocalltest.html
    // await janus.initClient(
    //   '62.109.30.185',
    //   '',
    //   '28d7059e-4efb-48e1-9766-8122413ade05',
    // );
    // janus.makeCall('16a1fd98-70e9-40bb-96b3-120cebab68fa');
  }

  Future<void> onBackCallTap() async {
    MetricaService.event('device_back_call_tap', {'oid': device.oid});
    final ret = await navigator.push(BackCallViewRoute(device.oid));
    if (ret == null) return;
    notifyListeners();
  }

  Future<void> onTakePhotoTap() async {
    MetricaService.event('device_photo_tap', {'oid': device.oid});
    setBusy(true);
    try {
      final ret = await api.getPhotoFromDevice(device.oid);
      logger.i(ret);
      if (ret == 0) {
        showAppDialog(title: 'Ожидайте фото с устройства', subtitle: 'Запрос отправлен');
      }
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        // проверьте интернет
        final retry = await showAppDialog(
          title: Strings.current.error,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == true) onTakePhotoTap();
        return;
      }
      switchError(e.error);
    } finally {
      setBusy(false);
    }
    notifyListeners();
  }

  Future<void> onSearchTap() async {
    MetricaService.event('device_search_tap', {'oid': device.oid});
    setBusy(true);
    try {
      final ret = await api.enableObjectFindZummer(device.oid);
      logger.i(ret);
      if (ret == 0) {
        showAppDialog(
            title: 'Ожидайте сигнала с устройства', subtitle: 'Запрос отправлен');
      }
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        // проверьте интернет
        final retry = await showAppDialog(
          title: Strings.current.error,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == true) onTakePhotoTap();
        return;
      }
      switchError(e.error);
    } finally {
      setBusy(false);
    }
    notifyListeners();
  }

  Future<void> onMovingTap() async {
    MetricaService.event('device_history_tap', {'oid': device.oid});
    final ret = await navigator.push(HistoryDisplacementsViewRoute(device: device));
    if (ret == null) return;
    notifyListeners();
  }

  Future<void> onGeozonesTap() async {
    MetricaService.event('device_geozones_tap', {'oid': device.oid});
    final ret = await navigator.push(GeozonesViewRoute(device: device));
    if (ret == null) return;
    notifyListeners();
  }

  Future<void> onGalleryTap() async {
    MetricaService.event('device_gallery_tap', {'oid': device.oid});
    navigator.push(GalleryViewRoute(device.oid));
  }

  Future<void> onDoNotDistrubTap() async {
    MetricaService.event('device_dnd_tap', {'oid': device.oid});
    final ret = await rootNavigator.push(DndsViewRoute(device: device));
    if (ret == null) return;
    notifyListeners();
  }

  Future<void> onHealthTap() async {
    MetricaService.event('device_health_tap', {'oid': device.oid});
    navigator.push(HealthViewRoute(device));
  }

  Future<void> onAlarmClockTap() async {
    MetricaService.event('device_alarm_tap', {'oid': device.oid});
    final ret = await rootNavigator.push(AlarmClocksViewRoute(device: device));
    if (ret == null) return;
    notifyListeners();
  }

  Future<void> onSettingsTap() async {
    MetricaService.event('device_settings_tap', {'oid': device.oid});
    final ret = await navigator.push(SettingsViewRoute(device));
    if (ret == null) return;
  }

  Future<void> onRebootTap(BuildContext context) async {
    MetricaService.event('device_reboot_tap', {'oid': device.oid});
    setBusy(true);
    try {
      final ret = await api.restartDevice(device.oid);
      logger.i(ret);
      if (ret == 'RESET') {
        showAppDialog(title: 'Устройство перезагружается', subtitle: 'Запрос отправлен');
      }
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        final retry = await showAppDialog(
          title: Strings.current.error,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == true) onTakePhotoTap();
        return;
      }
      switchError(e.error);
    } finally {
      setBusy(false);
    }
  }

  Future<void> onOffTap(BuildContext context) async {
    MetricaService.event('device_off_tap', {'oid': device.oid});
    setBusy(true);
    try {
      final ret = await api.shutdownDevice(device.oid);
      logger.i(ret);
      if (ret == 'POWEROFF') {
        showAppDialog(title: 'Устройство выключено', subtitle: 'Запрос отправлен');
      }
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        final retry = await showAppDialog(
          title: Strings.current.error,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == true) onTakePhotoTap();
        return;
      }
      switchError(e.error);
    } finally {
      setBusy(false);
    }
  }
}
