import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'app/locator.dart';
import 'data/services/metrica.dart';
import 'data/services/thrid.dart';
import 'ui/app.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => port == 8989;
  }
}


Future<void> main() async {
  await GetStorage.init();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();
  MetricaService();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  setupLocator();
  setupSnackBar();
  run();
}

void run() {
  runApp(
    App(),
  );
}
