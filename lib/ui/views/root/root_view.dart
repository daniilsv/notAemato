import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/dashboard/dashboard_view.dart';
import 'package:notaemato/ui/views/events/events_view.dart';
import 'package:notaemato/ui/views/menu_page/menu_page.dart';
import 'package:notaemato/ui/views/messages/messages_view.dart';
import 'package:notaemato/ui/views/start/start_view.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'root_viewmodel.dart';
import 'widgets/root_bottom_bar.dart';

class RootViewRoute extends CupertinoPageRoute {
  RootViewRoute() : super(builder: (context) => RootView());
}

class RootView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RootViewModel>.reactive(
      viewModelBuilder: () => RootViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        if (!model.isLoggedIn) return StartView();
        return DoubleBack(
          message: "Повторите, чтобы выйти из приложения",
          child: WillPopScope(
            onWillPop: model.onWillPop,
            child: DecoratedBox(
              decoration: const BoxDecoration(color: AppColors.bg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: IndexedStack(
                      index: model.navigatorService.indexPage,
                      children: [
                        Navigator(
                          key: model.navigatorKeys[0],
                          onGenerateInitialRoutes: (a, b) => [DashboardViewRoute()],
                        ),
                        Navigator(
                          key: model.navigatorKeys[1],
                          onGenerateInitialRoutes: (a, b) => [MessagesViewRoute()],
                        ),
                        Navigator(
                          key: model.navigatorKeys[2],
                          onGenerateInitialRoutes: (a, b) => [EventsViewRoute()],
                        ),
                        Navigator(
                          key: model.navigatorKeys[3],
                          onGenerateInitialRoutes: (a, b) => [MenuViewRoute()],
                        ),
                      ],
                    ),
                  ),
                  RootBottomBar(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
