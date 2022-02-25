import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/activity.dart';
import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/data/model/pulse.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HealthViewModel extends BaseViewModel {
  HealthViewModel(BuildContext context) {
    device = ModalRoute.of(context)!.settings.arguments as DeviceModel?;
    navigator = Navigator.of(context);
    rootNavigator = Navigator.of(context, rootNavigator: true);
  }
  // Services
  final SocketApi api = locator<SocketApi>();
  late NavigatorState navigator;
  late NavigatorState rootNavigator;
  late int? index;
  bool get notThisDay => datePuls.isBefore(
      Jiffy.unix(DateTime.now().millisecondsSinceEpoch).startOf(Units.DAY).dateTime);

  // Constants

  // Controllers
  TooltipBehavior tooltipBehavior = TooltipBehavior(
                  enable: true,
                  color: AppColors.health,
                  elevation: 8,
                  header: 'Пульс',
                  format: 'в point.x - point.y уд/м'
                );
  ZoomPanBehavior zoomPanBehavior = ZoomPanBehavior(
                  enablePanning: true,
                  enablePinching: true,
                );              

  // Variables
  ActivityModel? activity;
  PulseModel? pulse;
  DeviceModel? device;
  DateTime datePuls =
      Jiffy.unix(DateTime.now().millisecondsSinceEpoch).endOf(Units.DAY).dateTime;

  // Logic

  Future onReady() async {
    setBusy(true);
    await getActivityHistory();
    await getPulseHistory(datePuls);
    setBusy(false);
  }

  Future<void> getActivityHistory() async {
    activity = await api.getActivityHistory(device!.oid, DateTime.now(), 7);
    notifyListeners();
  }

  Future<void> getPulseHistory(DateTime date) async {
    pulse = await api.getPulseHistory(device!.oid, date, 1);
    notifyListeners();
  }

  Future<void> prevDayTap() async {
    datePuls = datePuls.subtract(const Duration(days: 1));
    getPulseHistory(datePuls);
  }

  Future<void> nextDayTap() async {
    datePuls = datePuls.add(const Duration(days: 1));
    getPulseHistory(datePuls);
  }

  Future<void> onDateTap(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: datePuls,
        firstDate: DateTime(2021),
        lastDate: DateTime.now());
    if (picked != null && picked != datePuls) datePuls = picked;
    await getPulseHistory(datePuls);
    notifyListeners();
  }

  List<ChartSeries> getPulsData() {
    final List<Measurements> chartData = pulse!.days!.last.measurements!;
    return <ChartSeries>[
      SplineSeries<Measurements, DateTime>(
        splineType: SplineType.monotonic,
        dataSource: chartData,
        xValueMapper: (Measurements x, _) => Jiffy.unix(x.ts!).dateTime,
        yValueMapper: (Measurements y, _) => y.pulse,
        width: 2,
        enableTooltip: true, 
        color: AppColors.health,
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 2,
          width: 2,
          shape: DataMarkerType.circle,
          borderWidth: 2,
          borderColor: AppColors.red,
        ),
      )
    ];
  }

  List<ChartSeries> getStepsData() {
    final List<ActivityDays> chartData = activity!.days!;
    return <ChartSeries>[
      ColumnSeries<ActivityDays, DateTime>(
        dataSource: chartData,
        xValueMapper: (ActivityDays x, _) => Jiffy.unix(x.ts!).dateTime,
        yValueMapper: (ActivityDays y, _) => y.steps,
        color: AppColors.health,
      ),
    ];
  }

  List<ChartSeries> getKKalData() {
    final List<ActivityDays> chartData = activity!.days!;
    return <ChartSeries>[
      ColumnSeries<ActivityDays, DateTime>(
        dataSource: chartData,
        xValueMapper: (ActivityDays x, _) => Jiffy.unix(x.ts!).dateTime,
        yValueMapper: (ActivityDays y, _) => y.kcal,
        color: AppColors.health,
      ),
    ];
  }
}
