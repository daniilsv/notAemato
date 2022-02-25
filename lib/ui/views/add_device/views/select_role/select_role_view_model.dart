import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class SelectRoleViewModel extends BaseViewModel {
  SelectRoleViewModel(BuildContext context) {
    roleController.text = ModalRoute.of(context)!.settings.arguments as String? ?? '';
    navigator = Navigator.of(context);
    roleController.addListener(notifyListeners);
  }
  // Constants
  final List<String> roles = [
    Strings.current.father,
    Strings.current.mother,
    Strings.current.grandpa,
    Strings.current.grandma,
  ];

  // Controllers
  final roleController = TextEditingController();

  // Variables
  late NavigatorState navigator;

  // Logic
  bool value(int index) {
    return roles[index].toLowerCase() == roleController.text.toLowerCase();
  }

  void onDone() {
    navigator.pop(roleController.text);
  }

  void setRole(int index) {
    roleController.text = roles[index];
    notifyListeners();
  }
}
