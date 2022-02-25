import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'events_viewmodel.dart';
import 'widgets/event_tile.dart';

class EventsViewRoute extends CupertinoPageRoute {
  EventsViewRoute() : super(builder: (context) => const _EventsView());
}

class _EventsView extends StatelessWidget {
  const _EventsView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EventsViewModel>.reactive(
      viewModelBuilder: () => EventsViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          title: 'События',
          implyLeading: false,
          body: ListView.separated(
            padding: const EdgeInsets.only(bottom: 16, left: 16),
            itemBuilder: (context, index) {
              final event = model.events[index];
              // if (event.device!.personId != null)
              return EventTile(
                title: model.getTitle(event),
                subtitle: model.getPerson(event.device!).name!,
                photoUrl: model.getPerson(event.device!).photoUrl,
                eventDate: event.event!.ts,
              );
            },
            separatorBuilder: (context, index) =>
                const Divider(height: 32, thickness: 1, indent: 64),
            itemCount: model.events.length,
          ),
        );
      },
    );
  }
}
