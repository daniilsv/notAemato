import 'package:notaemato/data/model/device.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class EditContactViewModel extends BaseViewModel {
  EditContactViewModel(BuildContext context) {
    contact = ModalRoute.of(context)!.settings.arguments as PhonebookPhone?;
    navigator = Navigator.of(context);
    nameController.text = contact?.name ?? '';
    phoneController.text = contact?.phone?.replaceAll(RegExp(r'(?:_|[^\w\\+])+'), '') ?? '';
    nameController.addListener(notifyListeners);
    phoneController.addListener(notifyListeners);
  }
  // Services
  late NavigatorState navigator;
  late PhonebookPhone? contact;

  // Constants

  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  // Variables

  // Logic
  bool get isActive => nameController.text.isNotEmpty && phoneController.text.isNotEmpty;

  Future onReady() async {}

  Future<void> onSaveTap() async {
    navigator.pop(PhonebookPhone(phone: phoneController.text.replaceAll(RegExp(r'(?:_|[^\w\\+])+'), ''), name: nameController.text));
  }
}
