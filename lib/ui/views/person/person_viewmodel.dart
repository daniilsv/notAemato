import 'dart:io';

import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/api/api.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/dto/socket_error.dart';
import 'package:notaemato/data/model/person.dart';
import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/data/services/persons.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';
import 'package:supercharged/supercharged.dart';

class PersonViewModel extends BaseViewModel {
  PersonViewModel(BuildContext context) {
    navigator = Navigator.of(context);
    initial = ModalRoute.of(context)!.settings.arguments as PersonModel?;
    if (initial != null) {
      nameController.text = initial!.name!;
      dateController.text = Jiffy(initial!.dateOfBirth).yMd;
      weightController.text = initial!.weight.toString();
      heightController.text = initial!.height.toString();
    }
  }
  // Services
  late NavigatorState navigator;
  final SocketApi api = locator<SocketApi>();
  final PersonsService personsService = locator<PersonsService>();

  // Constants
  PersonModel? initial;

  // Controllers
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  DateFormat dateFormat = DateFormat.yMd();

  // Variables
  File? localPhoto;
  bool get isActive =>
      nameController.text.isNotEmpty &&
      dateController.text.isNotEmpty &&
      weightController.text.isNotEmpty &&
      heightController.text.isNotEmpty;
  DateTime selectedDate = DateTime.now();

  // Logic

  Future onReady() async {
    nameController.addListener(notifyListeners);
    dateController.addListener(notifyListeners);
    weightController.addListener(notifyListeners);
    heightController.addListener(notifyListeners);
  }

  Future<void> pickPhoto(BuildContext context) async {
    MetricaService.event('person_pick_photo');
    try {
      final source = await showCupertinoDialog<ImageSource>(
        context: context,
        barrierDismissible: true,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Выбрать фото'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(ImageSource.gallery);
              },
              child: Text('Из галереи'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(ImageSource.camera);
              },
              child: Text('Сделать фото'),
            ),
          ],
        ),
      );
      if (source == null) return;
      final pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 80);
      if (pickedFile == null) return;
      setBusy(true);
      final croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square],
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
    } finally {
      setBusy(false);
    }
    notifyListeners();
  }

  Future datePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) selectedDate = picked;
    dateController.text = dateFormat.format(selectedDate);
    notifyListeners();
  }

  void removePhoto() {
    localPhoto = null;
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    if (initial != null)
      MetricaService.event('person_update', {'personId': initial!.personId});
    else
      MetricaService.event('person_create');
    setBusy(true);
    final person = PersonModel(
      personId: initial?.personId,
      name: nameController.text,
      dateOfBirth: dateController.text,
      height: heightController.text.toInt(),
      weight: weightController.text.toInt(),
    );
    if (person != initial) {
      try {
        final ret = await api.upsertPerson(person);
        logger.i(ret);
        if (ret != null) {
          person.personId = ret;
        }
        Fluttertoast.showToast(
            msg: "Персона сохранена",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (initial == null && localPhoto == null) {
          navigator.pop(person);
          await personsService.update(force: true);
          return;
        }
      } on SocketError catch (e) {
        if (e == SocketError.noInternet) {
          // проверьте интернет
          setBusy(false);
          final retry = await showAppDialog(
            actionTitle: Strings.current.retry,
          );
          if (retry == true) save(context);
          return;
        }
        switch (e.error) {
          case 9000:
            showAppDialog();
            break;
        }
      } finally {}
    }
    if (localPhoto != null) {
      final uploadUrl = await api.getUploadPersonPhotoUrl(person.personId);
      if (uploadUrl != null) {
        try {
          final ret =
              await locator<Api>().upload.upload(url: uploadUrl, file: localPhoto);
          logger.i(ret);
          if (ret.photoUrl != null) {
            person.photoUrl = ret.photoUrl;
            Fluttertoast.showToast(
                msg: "Фото сохранено",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
          if (ret.photoUrl == null) {
            Fluttertoast.showToast(
                msg: "Ошибка сохранения фото",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } on DioError catch (e) {
          switch (e.error) {
            case 413:
              showAppDialog();
              break;
            case 400:
              showAppDialog();
              break;
          }
        } finally {}
      }
      if (initial == null) {
        navigator.pop(person);
      }
    }
    await personsService.update(force: true);
    if (initial == null) navigator.pop();
    setBusy(false);
  }
}
