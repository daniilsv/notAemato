import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/model/user.dart';
import 'package:notaemato/data/services/devices.dart';
import 'package:notaemato/data/services/persons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'auth.dart';

@lazySingleton
class NavigatorService extends ChangeNotifier implements OnAuthListener {
  NavigatorService() {
    authService.addAuthListener(this);
  }

  final authService = locator<AuthService>();
  final navigatorKeys = <GlobalKey<NavigatorState>>[
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  int indexPage = 0;

  void changePage(int index) {
    if (indexPage == index) {
      final nav = navigatorKeys[index].currentState!;
      //TODO ?? temp
      locator<DevicesService>().update();
      locator<PersonsService>().update();
      nav.popUntil((route) => route.isFirst);
      return;
    }
    indexPage = index;
    notifyListeners();
  }

  @override
  void onExit() {}

  @override
  void onUser(UserModel user) {
    indexPage = 0;
    notifyListeners();
  }
}
