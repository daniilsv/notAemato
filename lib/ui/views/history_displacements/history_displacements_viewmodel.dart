import 'package:notaemato/app/locator.dart';
import 'package:notaemato/app/logger.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/dto/socket_error.dart';
import 'package:notaemato/data/model/history.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/views/history_map/history_map_view.dart';
import 'package:notaemato/ui/widgets/app_dialog.dart';
import 'package:notaemato/ui/widgets/switch_error.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';

class HistoryDisplacementsViewModel extends BaseViewModel {
  HistoryDisplacementsViewModel(BuildContext context) {
    device = ModalRoute.of(context)!.settings.arguments as DeviceModel?;
    navigator = Navigator.of(context);
    rootNavigator = Navigator.of(context, rootNavigator: true);
  }
  // Services
  NavigatorState? navigator;
  NavigatorState? rootNavigator;
  final SocketApi api = locator<SocketApi>();

  // Constants
  DeviceModel? device;
  Map<DateTime, List<HistoryPoint>> history = {};
  // Controllers

  // Variables

  // Logic

  Future onReady() async {
    getHistory();
  }

  Future<void> getHistory() async {
    setBusy(true);
    try {
      final ret = await api.getObjectTrackStepPoints(device!.oid);
      logger.i(ret);
      if (ret != []) {
        for (var i = 0; i < 60; i++) {
          final day = DateTime.now().subtract(Duration(days: i));
          if (ret.any((element) => Jiffy.unix(element.ts!).dateTime.day == day.day))
            history[day] = ret
                .where((element) => Jiffy.unix(element.ts!).dateTime.day == day.day)
                .toList();
        }
      }
    } on SocketError catch (e) {
      if (e == SocketError.noInternet) {
        final retry = await showAppDialog(
          title: Strings.current.error,
          subtitle: Strings.current.check_you_internet,
          actionTitle: Strings.current.retry,
        );
        if (retry == true) getHistory();
        return;
      }
      switchError(e.error);
    } finally {
      setBusy(false);
    }
  }

  int? getSteps(DateTime? day) {
    var sum = 0;

    for (var i = 0; i < history[day]!.length; i++) {
      sum += history[day]![i].stepCount!;
    }
    return sum.toInt();
  }

  void onHistoryItemTap(List<HistoryPoint> points) {
    rootNavigator!.push(HistoryMapViewRoute(points: points));
  }
}
