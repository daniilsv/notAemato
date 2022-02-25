import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'messages_viewmodel.dart';
import 'widgets/message_tile.dart';

class MessagesViewRoute extends CupertinoPageRoute {
  MessagesViewRoute() : super(builder: (context) => const _MessagesView());
}

class _MessagesView extends StatelessWidget {
  const _MessagesView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessagesViewModel>.reactive(
      viewModelBuilder: () => MessagesViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          title: 'Сообщения',
          implyLeading: false,
          body: ListView.separated(
            padding: const EdgeInsets.only(bottom: 16, left: 16),
            itemBuilder: (context, index) {
              return Tappable(
                onPressed: () => model.onPersonTap(model.devices[index]),
                child: MessageTile(
                  title: model.persons[model.devices[index].personId]?.personId == 0 ||
                          model.persons[model.devices[index].personId]?.personId == null
                      ? 'Не привязано'
                      : model.persons[model.devices[index].personId]?.name ?? '',
                  subtitle: model
                      .getLastMessageString(model.messages[model.devices[index]]?.first),
                  photoUrl: model.persons[model.devices[index].personId]?.photoUrl,
                  lastMessageDate: model
                      .getLastMessageDate(model.messages[model.devices[index]]?.first),
                  newMessageCount:
                      model.messages[model.devices[index]]?.length ?? 0, //TODO this wrong
                ),
              );
            },
            separatorBuilder: (context, index) =>
                const Divider(height: 32, thickness: 1, indent: 64),
            itemCount: model.devices.length,
          ),
        );
      },
    );
  }
}
