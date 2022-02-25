import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_card.dart';
import 'package:notaemato/ui/widgets/app_header_action.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'health_viewmodel.dart';

class HealthViewRoute extends CupertinoPageRoute {
  HealthViewRoute(DeviceModel device)
      : super(
            builder: (context) => const HealthView(),
            settings: RouteSettings(arguments: device));
}

class HealthView extends StatelessWidget {
  const HealthView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HealthViewModel>.reactive(
      viewModelBuilder: () => HealthViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          bg: AppColors.dashboardBg,
          title: 'Здоровье',
          isBusy: model.isBusy,
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              if (model.pulse != null && model.pulse!.days!.isNotEmpty)
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Пульс', style: AppStyles.titleCard),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        child: SfCartesianChart(
                          zoomPanBehavior: model.zoomPanBehavior,
                          tooltipBehavior: model.tooltipBehavior,
                          selectionType: SelectionType.point,
                          primaryXAxis: DateTimeAxis(
                            intervalType: DateTimeIntervalType.hours,
                            minimum: Jiffy.unix(model.datePuls.millisecondsSinceEpoch)
                                .startOf(Units.DAY)
                                .dateTime,
                            maximum: Jiffy.unix(model.datePuls.millisecondsSinceEpoch)
                                .endOf(Units.DAY)
                                .dateTime,
                            interval: 4,
                            dateFormat: DateFormat.Hm(),
                          ),
                          primaryYAxis: NumericAxis(
                            plotBands: <PlotBand>[
                              PlotBand(
                                start: model.pulse?.pulse?.max,
                                end: model.pulse?.pulse?.max,
                                borderWidth: 2,
                                borderColor: AppColors.red,
                                dashArray: <double>[2, 2],
                              )
                            ],
                            minimum: 30,
                            maximum:
                                model.pulse!.days!.last.measurements!.isEmpty ? 80 : null,
                          ),
                          series: model.pulse != null ? model.getPulsData() : null,
                        ),
                      ),
                      Row(
                        children: [
                          AppHeaderAction(
                              onTap: model.prevDayTap,
                              icon: Icons.arrow_left_rounded,
                              right: 0),
                          Expanded(
                            child: Center(
                              child: Tappable(
                                onPressed: () => model.onDateTap(context),
                                child: Text(
                                  Jiffy.unix(model.datePuls.millisecondsSinceEpoch)
                                      .yMMMEd,
                                  style: AppStyles.titleCard,
                                ),
                              ),
                            ),
                          ),
                            AppHeaderAction(
                              onTap: model.notThisDay ? model.nextDayTap : () {},
                              icon: Icons.arrow_right_rounded,
                              right: 0,
                            )                    
                        ],
                      )
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              if (model.activity != null && model.activity!.days!.isNotEmpty) ...[
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Шаги', style: AppStyles.titleCard),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        child: SfCartesianChart(
                          selectionType: SelectionType.point,
                          primaryXAxis: DateTimeAxis(
                            intervalType: DateTimeIntervalType.days,
                            interval: 1,
                            minimum: Jiffy.unix(DateTime.now()
                                    .subtract(const Duration(days: 5))
                                    .millisecondsSinceEpoch)
                                .startOf(Units.DAY)
                                .dateTime,
                            maximum: Jiffy.unix(DateTime.now().millisecondsSinceEpoch)
                                .endOf(Units.DAY)
                                .dateTime
                                .add(const Duration(days: 0)),
                            dateFormat: DateFormat.Md(),
                          ),
                          primaryYAxis: NumericAxis(
                            plotBands: <PlotBand>[
                              PlotBand(
                                start: model.activity?.dailyStepsGoal,
                                end: model.activity?.dailyStepsGoal,
                                borderWidth: 2,
                                borderColor: AppColors.green,
                                dashArray: <double>[2, 2],
                              )
                            ],
                          ),
                          series: model.activity != null ? model.getStepsData() : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Калории', style: AppStyles.titleCard),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                        child: SfCartesianChart(
                          selectionType: SelectionType.point,
                          primaryXAxis: DateTimeAxis(
                            intervalType: DateTimeIntervalType.days,
                            interval: 1,
                            minimum: Jiffy.unix(DateTime.now()
                                    .subtract(const Duration(days: 5))
                                    .millisecondsSinceEpoch)
                                .startOf(Units.DAY)
                                .dateTime,
                            maximum: Jiffy.unix(DateTime.now().millisecondsSinceEpoch)
                                .endOf(Units.DAY)
                                .dateTime
                                .add(const Duration(days: 0)),
                            dateFormat: DateFormat.Md(),
                          ),
                          primaryYAxis: NumericAxis(),
                          series: model.activity != null ? model.getKKalData() : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24)
            ],
          ),
        );
      },
    );
  }
}
