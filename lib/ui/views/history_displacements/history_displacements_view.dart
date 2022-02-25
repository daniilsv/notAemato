import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'history_displacements_viewmodel.dart';
import 'widgets/history_tile.dart';

class HistoryDisplacementsViewRoute extends CupertinoPageRoute {
  HistoryDisplacementsViewRoute({DeviceModel? device})
      : super(
            builder: (context) => const HistoryDisplacementsView(),
            settings: RouteSettings(arguments: device));
}

class HistoryDisplacementsView extends StatelessWidget {
  const HistoryDisplacementsView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HistoryDisplacementsViewModel>.reactive(
      viewModelBuilder: () => HistoryDisplacementsViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          isBusy: model.isBusy,
            title: 'История перемещений',
            body: [
              if (model.history.isEmpty && !model.isBusy)
                const Center(child: Text('Данных нет :('),)
              else
                ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  itemBuilder: (context, index) {
                    return Tappable(
                      onPressed: () => model.onHistoryItemTap(model.history.values.elementAt(index)),
                      child: HistoryTile(
                        date: model.history.keys.elementAt(index),
                        steps: model.getSteps(model.history.keys.elementAt(index)),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 24),
                  itemCount: model.history.keys.length,
                ),
            ].last);
      },
    );
  }
}
