import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/history_displacements/history_displacements_view.dart';
import 'package:notaemato/ui/views/person_selection/person_selection_view.dart';
import 'package:notaemato/ui/views/test_ui/push_logs/push_logs_view.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/app_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'push_logs/../test_ui_viewmodel.dart';

class TestUiViewRoute extends CupertinoPageRoute {
  TestUiViewRoute() : super(builder: (context) => const TestUiView());
}

class TestUiView extends StatelessWidget {
  const TestUiView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TestUiViewModel>.reactive(
      viewModelBuilder: () => TestUiViewModel(),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return Column(
          children: [
            Expanded(
              child: AppScaffold(
                title: 'Ла-ла-ла-ла-ла-ла-ла-ла-ла-ла-ла',
                body: ListView(padding: AppPaddings.all20, children: [
                  AppButton(
                    text: 'Переключить второй Scaffold',
                    onPressed: model.toggleSecondScaf,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'История перемещений',
                    onPressed: () =>
                        Navigator.of(context).push(HistoryDisplacementsViewRoute()),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'Error',
                    onPressed: () =>
                        showAppDialog(action: showAppDialog, actionTitle: 'Повторить'),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'Push logs',
                    onPressed: () => Navigator.push(context, PushLogsViewRoute()),
                  ),
                ]),
              ),
            ),
            if (model.secondScaf)
              Expanded(
                child: AppScaffold(
                  title: 'Ла-ла-ла-ла-ла-ла-ла-ла-ла-ла-ла',
                  leadingRight: true,
                  body: ListView(
                    padding: AppPaddings.all20,
                    children: [
                      AppButton(
                        text: 'Переключить второй Scaffold',
                        onPressed: model.toggleSecondScaf,
                      )
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
