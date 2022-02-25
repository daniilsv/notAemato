import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:notaemato/data/api/api.dart';
import 'package:notaemato/data/services/persons.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

import 'devices.dart';

@lazySingleton
class MarkersService with ReactiveServiceMixin {
  MarkersService(this._devicesService, this._personsService, this._api) {
    _personsService.rawPersons.addListener(generateMarkers);
    listenToReactiveValues([loading, bitmaps]);
  }
  late final Api _api;
  late final PersonsService _personsService;
  late final DevicesService _devicesService;
  final ValueNotifier<bool> loading = ValueNotifier(false);
  final ValueNotifier<Map<String, BitmapDescriptor>> bitmaps = ValueNotifier({});
  final Map<String?, BitmapDescriptor?> _bitmaps = {};
  Future<void> generateMarkers() async {
    loading.value = true;
    _bitmaps[null] ??= await base64ToImage(null);
    for (final device in _devicesService.devices.val!) {
      final person = _personsService.persons[device.personId];
      if (person == null) continue;
      if (_bitmaps.containsKey(person.photoUrl) || _bitmaps[person.photoUrl] != null)
        continue;
      _bitmaps[person.photoUrl] = null;
      final photo = await tryLoad(person.photoUrl!);
      _bitmaps[person.photoUrl] = await base64ToImage(photo);
    }
    bitmaps.value = Map.from(_bitmaps);
    loading.value = false;
  }

  Future<Uint8List?> tryLoad(String url) async {
    try {
      final cacheDir = (await getExternalCacheDirectories())!.first.path;
      final local = File('$cacheDir/tmp.${url.split('.').last}');
      await _api.dio.download(url, local.path);
      return local.readAsBytes();
    } on Object {
      return null;
    }
  }

  Future<BitmapDescriptor> base64ToImage(Uint8List? imageBytes) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    canvas.scale(window.devicePixelRatio / 1, window.devicePixelRatio / 1);
    const size = Size(48, 48);
    const center = Offset(24, 21);
    const triangle = [
      Offset(24.0 - 4, 40),
      Offset(24.0 + 4, 40),
      Offset(24.0, 40.0 + 8),
    ];
    const centerShadow = Offset(24, 24);
    // const triangleShadow = [
    //   Offset(36.0 - 6, 72),
    //   Offset(36.0 + 6, 72),
    //   Offset(36.0, 72.0 + 13),
    // ];
    final _img = imageBytes == null ? null : await decodeImageFromList(imageBytes);
    final path = Path()
      // ..addPolygon(triangleShadow, true)
      ..addOval(Rect.fromCircle(center: centerShadow, radius: 20));
    canvas.drawShadow(path, const Color(0x25000000), 3, true);
    canvas.clipPath(Path()
      ..addPolygon(triangle, true)
      ..addOval(Rect.fromCircle(center: center, radius: 20)));
    canvas.drawCircle(center, 20, Paint()..color = AppColors.primary);
    if (_img != null) {
      final minSide = min(_img.width, _img.height) + .0;
      canvas.drawImageRect(
        _img,
        Rect.fromCenter(
            center: Rect.fromLTWH(0, 0, _img.width + .0, _img.height + .0).center,
            width: minSide,
            height: minSide),
        Rect.fromCenter(center: center, width: 38, height: 38),
        Paint(),
      );
    } else {
      canvas.drawRect(
        Rect.fromCenter(center: center, width: 38, height: 38),
        Paint()..color = AppColors.primary,
      );
      canvas.drawCircle(center, 6, Paint()..color = Colors.white);
    }
    canvas.drawCircle(
        center,
        20,
        Paint()
          ..strokeWidth = 6
          ..style = PaintingStyle.stroke
          ..color = Colors.white);

    canvas.drawPath(Path()..addPolygon(triangle, true), Paint()..color = Colors.white);
    // canvas.scale(1.5 / window.devicePixelRatio, 1.5 / window.devicePixelRatio);
    final pic = pictureRecorder.endRecording();
    final img = await pic.toImage(
      (window.devicePixelRatio * size.width).toInt(),
      (window.devicePixelRatio * size.height).toInt(),
    );
    final byteData =
        await (img.toByteData(format: ImageByteFormat.png) as FutureOr<ByteData>);
    return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
  }
}
