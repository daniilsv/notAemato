import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class RepeatAlarmsViewModel extends BaseViewModel {
  RepeatAlarmsViewModel(BuildContext context) {
    navigator = Navigator.of(context);
    final initial = ModalRoute.of(context)!.settings.arguments as List<bool>?;
    if (initial is List<bool>) {
      repeat = initial;
    }
  }
  // Services
  late NavigatorState navigator;

  // Constants
  List<bool> repeat = [false, false, false, false, false, false, false];

  // Controllers

  // Variables

  // Logic
  String getDayName(int index) {
    //TODO: add weekdays by locale
    if (index == 0) return 'Понедельник';
    if (index == 1) return 'Вторник';
    if (index == 2) return 'Среда';
    if (index == 3) return 'Четверг';
    if (index == 4) return 'Пятница';
    if (index == 5) return 'Суббота';
    if (index == 6) return 'Воскресенье';
    return '';
  }

  void onChanged(int index) {
    repeat[index] = !repeat[index];
    notifyListeners();
  }

  void onPop() {
    navigator.pop(repeat);
  }
}
