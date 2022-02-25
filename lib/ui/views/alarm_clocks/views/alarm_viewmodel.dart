import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/views/alarm_clocks/views/repeat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';

class AlarmViewModel extends BaseViewModel {
  AlarmViewModel(BuildContext context) {
    navigator = Navigator.of(context);
    initial = ModalRoute.of(context)!.settings.arguments as AlarmClock?;
    if (initial is AlarmClock) {
      alarm = initial!;
    }
  }
  // Services
  late NavigatorState navigator;

  // Constants
  AlarmClock? initial;
  AlarmClock alarm = AlarmClock(
    hours: 09,
    minutes: 00,
    repeat: [false, false, false, false, false, false, false],
    enabled: true,
  );

  // Controllers
  final timeController = TextEditingController();
  final repeatController = TextEditingController();

  // Variables

  // Logic

  Future onReady() async {
    timeController.text = Jiffy('${alarm.hours}:${alarm.minutes}', 'HH:mm').Hm;
    repeatController.text = getRepeatString(alarm.repeat!);
  }

  Future onTimeTap(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      context: context,
    );
    if (picked != null) {
      alarm.hours = picked.hour;
      alarm.minutes = picked.minute;
    }
    onReady();
    notifyListeners();
  }

  Future<void> onRepeatTap(List<bool> repeat) async {
    final ret = await navigator.push(RepeatAlarmsViewRoute(repeat: repeat));
    alarm.repeat = ret;
    repeatController.text = getRepeatString(alarm.repeat!);
    notifyListeners();
  }

  String getRepeatString(List<bool> repeat) {
    final List<String> string = [];
    //TODO: add short weekdays by locale
    if (repeat[0]) string.add('Пн');
    if (repeat[1]) string.add('Вт');
    if (repeat[2]) string.add('Ср');
    if (repeat[3]) string.add('Чт');
    if (repeat[4]) string.add('Пт');
    if (repeat[5]) string.add('Сб');
    if (repeat[6]) string.add('Вс');
    if (string.length == 7)
      string
        ..clear()
        ..add('Каждый день');
    if (string.isEmpty) string.add('Не повторять');
    return string.join(', ');
  }

  void onButtonTap() {
    final Map<bool, AlarmClock?> q = {};
    if (initial == null) q[true] = alarm;
    if (initial != null) q[false] = alarm;
    navigator.pop(q);
  }

  void onPop() {
    final Map<bool, AlarmClock?> q = {};
    if (initial != null) q[true] = alarm;
    navigator.pop(q);
  }
}
