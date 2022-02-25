import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/model/user.dart';
import 'package:notaemato/data/services/auth.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/data/services/janus.dart';
import 'package:notaemato/data/services/navigator.dart';
import 'package:notaemato/ui/views/profile/profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:supercharged/supercharged.dart';

import 'root_view.dart';

class RootViewModel extends BaseViewModel implements OnAuthListener {
  RootViewModel(BuildContext context) {
    navigator = Navigator.of(context);
    navigatorService.addListener(changePage);
    authService.addAuthListener(this);
  }
  late NavigatorState navigator;
  final _devicesService = locator<DevicesService>();
  final authService = locator<AuthService>();
  final navigatorService = locator<NavigatorService>();

  bool get isLoggedIn => authService.isLoggedIn;

  int? get messagesCount => authService.user!.messageBadgeCounter;

  int? get sharingCount => authService.user!.shareBadgeCounter;

  Future<void> onReady() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final host = prefs.getString('host');
    final token = prefs.getString('token');
    final caller = prefs.getString('caller');
    final callEvent = prefs.getString('callEvent');
    if (host != '' && host != null) {
      await locator<JanusService>().initClient(
        host,
        token ?? '',
        caller ?? '',
      );
      locator<JanusService>().addOverlay();
      // FlutterRingtonePlayer.play(
      //   android: AndroidSounds.ringtone,
      //   ios: IosSounds.bell,
      //   looping: true,
      // );
    }
  }

  List<GlobalKey<NavigatorState>> get navigatorKeys => navigatorService.navigatorKeys;
  void changePage() {
    notifyListeners();
  }

  @override
  void dispose() {
    authService.removeAuthListener(this);
    super.dispose();
  }

  @override
  void onExit() {
    navigator
      ..popUntil((route) => route.isFirst)
      ..pushReplacement(RootViewRoute());
    notifyListeners();
  }

  @override
  Future<void> onUser(UserModel user) async {
    if (authService.isNewUser) await navigator.push(ProfileViewRoute());
    while (_devicesService.loading.value != false)
      await Future<void>.delayed(500.milliseconds);
    // final devices = _devicesService.devices.val!;
    // if (devices.isEmpty) {
    //   await navigator.push(AddDeviceViewRoute());
    // }
    notifyListeners();
  }

  Future<bool> onWillPop() async {
    final nav = navigatorKeys[navigatorService.indexPage].currentState!;
    if (nav.canPop()) {
      nav.pop();
      return false;
    }
    return true;
  }
}
