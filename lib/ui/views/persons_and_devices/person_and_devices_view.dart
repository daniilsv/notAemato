import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/person_and_device_card.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'persons_and_devices_viewmodel.dart';

class PersonsAndDevicesViewRoute extends CupertinoPageRoute {
  PersonsAndDevicesViewRoute()
      : super(builder: (context) => const PersonsAndDevicesView());
}

class PersonsAndDevicesView extends StatelessWidget {
  const PersonsAndDevicesView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PersonsAndDevicesViewModel>.reactive(
      viewModelBuilder: () => PersonsAndDevicesViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          title: 'Персоны и устройства',
          isBusy: model.isBusy,
          onWillPop: model.onWillPop,
          body: model.persons.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  itemCount: model.persons.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 24),
                  padding: const EdgeInsets.all(24),
                  itemBuilder: (context, index) {
                    final device = model.devices.firstWhereOrNull(
                        (element) => element.personId == model.persons[index].personId);
                    return PersonAndDeviceCard(
                      onMenu: () => model.onMenuTap(context, model.persons[index]),
                      name: model.persons[index].name,
                      photoUrl: model.persons[index].photoUrl!.contains('webdav')
                          ? null
                          : model.persons[index].photoUrl,
                      device: device,
                    );
                  },
                )
              : const SizedBox(),
        );
      },
    );
  }
}
