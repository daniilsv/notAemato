import 'package:notaemato/data/model/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';

class DndViewModel extends BaseViewModel {
  DndViewModel(BuildContext context) {
    navigator = Navigator.of(context);
    initial = ModalRoute.of(context)!.settings.arguments as DndMode?;
    if (initial is DndMode) {
      dnd = initial!;
    }
  }
  // Services
  late NavigatorState navigator;

  // Constants
  DndMode? initial;
  DndMode dnd = DndMode(beginHour: 09, beginMinute: 00, endHour: 10, endMinute: 00);

  // Controllers
  final timeController = TextEditingController();
  final repeatController = TextEditingController();

  // Variables

  // Logic

  Future onReady() async {
    timeController.text = '${Jiffy(
                '${dnd.beginHour}:${dnd.beginMinute}',
                'HH:mm')
            .Hm}-${Jiffy('${dnd.endHour}:${dnd.endMinute}', 'HH:mm')
            .Hm}';
  }

  Future onTimeTap(BuildContext context) async {
    final TimeOfDay? begin = await showTimePicker(
      initialTime: TimeOfDay(hour: dnd.beginHour!, minute: dnd.beginMinute!),
      helpText: 'Укажите время начала интервала',
      context: context,
    );
    if (begin != null) {
      dnd.beginHour = begin.hour;
      dnd.beginMinute = begin.minute;
    }
    final TimeOfDay? end = await showTimePicker(
      initialTime: TimeOfDay(hour: dnd.endHour!, minute: dnd.endMinute!),
      helpText: 'Укажите время окончания интервала',
      context: context,
    );
    if (end != null) {
      dnd.endHour = end.hour;
      dnd.endMinute = end.minute;
    }
    onReady();
    notifyListeners();
  }

  void onButtonTap() {
    final Map<bool, DndMode?> q = {};
    if (initial == null) q[true] = dnd;
    if (initial != null) q[false] = dnd;
    navigator.pop(q);
  }

  void onPop() {
    final Map<bool, DndMode?> q = {};
    if (initial != null) q[true] = dnd;
    navigator.pop(q);
  }
}
