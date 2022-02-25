import 'dart:io' as io;

import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/images.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stacked/stacked.dart';

class GalleryViewModel extends BaseViewModel {
  GalleryViewModel(BuildContext context) {
    oid = ModalRoute.of(context)!.settings.arguments as int?;
  }
  // Services
  final SocketApi api = locator<SocketApi>();
  // Constants
  List<io.FileSystemEntity> files = [];
  late String directory;
  late int? oid;
  List<DeviceImage> images = [];

  // Controllers

  // Variables

  // Logic

  Future onReady() async {
    setBusy(true);
    images = await api.getObjectImages(oid);
    // directory = (await getApplicationDocumentsDirectory()).path;
    // files = io.Directory("$directory/$oid/").listSync();
    setBusy(false);
  }
}
