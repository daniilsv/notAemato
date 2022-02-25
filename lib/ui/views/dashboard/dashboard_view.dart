import 'package:notaemato/data/model/person.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_header_action.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/center_bottom.dart';
import 'package:notaemato/ui/widgets/map_marker.dart';
import 'package:notaemato/ui/widgets/person_card_title.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

import 'dashboard_viewmodel.dart';

class DashboardViewRoute extends CupertinoPageRoute {
  DashboardViewRoute() : super(builder: (context) => const DashboardView());
}

class DashboardView extends StatelessWidget {
  const DashboardView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
      viewModelBuilder: () => DashboardViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        if (model.devices.isEmpty)
          return CenterWithBottomButton(
              onPressed: model.onAddDeviceTap,
              title: 'Нет устройств',
              text: 'Добавьте устройства или отправьте запрос.',
              buttonTitle: Strings.current.add_device);
        return AppScaffold(
          bg: AppColors.dashboardBg,
          isBusy: model.isBusy,
          title: 'Дашборд',
          implyLeading: false,
          actions: [AppHeaderAction(onTap: model.onMapTap, icon: Icons.map)],
          body: [
            if (model.devices.isEmpty && model.persons.isEmpty)
              const SizedBox()
            else
              ListView.separated(
                padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                itemBuilder: (context, index) {
                  final PersonModel person =
                      model.persons[model.devices[index].personId] ?? model.tempPerson;

                  return Tappable(
                    onPressed: () => person.personId == 0 && model.persons.isNotEmpty ||
                            model.persons.isEmpty
                        ? model.onAddPersonTap(model.devices[index])
                        : model.onDeviceTap(model.devices[index]),
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: const [AppShadows.dashboard],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 152,
                              child: IgnorePointer(
                                child: Hero(
                                  tag: person.photoUrl ?? '',
                                  child: Stack(
                                    children: [
                                      GoogleMap(
                                        myLocationButtonEnabled: false,
                                        tiltGesturesEnabled: false,
                                        zoomGesturesEnabled: false,
                                        zoomControlsEnabled: false,
                                        liteModeEnabled: true,
                                        scrollGesturesEnabled: false,
                                        rotateGesturesEnabled: false,
                                        mapToolbarEnabled: false,
                                        compassEnabled: false,
                                        padding: const EdgeInsets.only(top: 200),
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(model.devices[index].lat!,
                                              model.devices[index].lon!),
                                          zoom: 15,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          child: MapMarker(photoUrl: person.photoUrl),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PersonCardTitle(
                                name: model.persons.isEmpty ? '...' : person.name ?? '',
                                deviceName: 'Часы: ${model.devices[index].type ?? ''}',
                                lastActiveTime: model.devices[index].states!.coordTs,
                                battaryPercent: model.devices[index].batteryPercent,
                                active: model.devices[index].online,
                              ),
                            )
                          ],
                        )),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemCount: model.devices.length,
              ),
          ].last,
        );
      },
    );
  }
}
