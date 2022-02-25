import 'dart:convert';

import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'push_logs_viewmodel.dart';

class PushLogsViewRoute extends CupertinoPageRoute {
  PushLogsViewRoute() : super(builder: (context) => const PushLogsView());
}

class PushLogsView extends StatelessWidget {
  const PushLogsView();

  String prettyJson(dynamic json) {
    const encoder = JsonEncoder.withIndent(' ');
    return encoder.convert(json);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PushLogsViewModel>.reactive(
      viewModelBuilder: () => PushLogsViewModel(),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          title: 'Push Logs',
          body: ListView.separated(
            padding: AppPaddings.all20,
            itemCount: model.items.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = model.items[index];
              return ListTile(
                isThreeLine: true,
                title: Text(item.date.toString()),
                subtitle: Text(
                  'notification:\n${prettyJson(item.notification)}\ndata:\n${prettyJson(item.data)}',
                ),
              );
            },
          ),
        );
      },
    );
  }
}
