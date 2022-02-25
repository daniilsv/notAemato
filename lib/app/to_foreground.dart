import 'dart:io';

import 'package:flutter/services.dart';

class ToForeground {
  ToForeground() {
    if (Platform.isAndroid)
      const MethodChannel('toforeground').invokeMethod("bring");
  }
}
