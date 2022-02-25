import 'dart:io';

import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/services/auth.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  ProfileViewModel(BuildContext context) {
    navigator = Navigator.of(context);
    if (!service.isNewUser) controller.text = service.user!.skytag!.replaceAll('#', '');
  }
  // Services
  late NavigatorState navigator;
  final AuthService service = locator<AuthService>();
  final SocketApi api = locator<SocketApi>();
  // Constants

  // Controllers
  TextEditingController controller = TextEditingController();

  bool get isValid => controller.text.isNotEmpty;

  // Variables
  File? localPhoto;
  // Logic

  Future onReady() async {
    controller.addListener(notifyListeners);
  }

  Future<void> pickPhoto(BuildContext context) async {
    final source = await showCupertinoDialog<ImageSource>(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Выбрать фото'),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              MetricaService.event('profile_pick_photo', {'source': 'gallery'});
              Navigator.of(context).pop(ImageSource.gallery);
            },
            child: Text('Из галереи'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              MetricaService.event('profile_pick_photo', {'source': 'camera'});
              Navigator.of(context).pop(ImageSource.camera);
            },
            child: Text('Сделать фото'),
          ),
        ],
      ),
    );
    if (source == null) return;
    final pickedFile = await ImagePicker().getImage(source: source, imageQuality: 80);
    if (pickedFile == null) return;
    final croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      compressQuality: 80,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [CropAspectRatioPreset.square],
      maxWidth: 512,
      maxHeight: 512,
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: '',
        toolbarColor: AppColors.bg,
        toolbarWidgetColor: AppColors.darkText,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      iosUiSettings: const IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );
    if (croppedFile == null) return;
    localPhoto = File(croppedFile.path);
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    setBusy(true);
    try {
      if (service.user!.skytag != controller.text) {
        MetricaService.event('profile_update_nickname');
        await service.updateSkytag(controller.text);
      }
      if (localPhoto != null) {
        MetricaService.event('profile_update_photo');
        await service.updatePhoto(localPhoto);
      }
    } finally {
      setBusy(false);
      Fluttertoast.showToast(
          msg: "Cохранено",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> logout(BuildContext context) async {
    final ret = await showAppDialog<String>(
      subtitle: '',
      title: 'Действительно выйти?',
      actionTitle: 'Выйти',
    );
    if (ret != 'Выйти') return;
    service.logout();
  }

  Future<bool> onWillPop() async {
    if (service.isNewUser) return false;
    //TODO: check new data => show modal
    return true;
  }
}
