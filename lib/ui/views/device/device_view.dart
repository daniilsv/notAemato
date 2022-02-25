import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/device/widgets/actions_card.dart';
import 'package:notaemato/ui/views/device/widgets/geozones_card.dart';
import 'package:notaemato/ui/views/device/widgets/health_card.dart';
import 'package:notaemato/ui/widgets/app_icon_button.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:stacked/stacked.dart';

import 'device_viemodel.dart';
import 'widgets/device_card.dart';
import 'widgets/persistent_header.dart';

class DeviceViewRoute extends CupertinoPageRoute {
  DeviceViewRoute(DeviceModel? device)
      : super(
          builder: (context) => const DeviceView(),
          settings: RouteSettings(arguments: device),
        );
}

class DeviceView extends StatelessWidget {
  const DeviceView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeviceViewModel>.reactive(
      viewModelBuilder: () => DeviceViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          isBusy: model.isBusy,
          body: CustomScrollView(
            controller: model.controller,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            slivers: [
              DeviceViewAppBar(
                mapLocation: LatLng(model.device.lat!, model.device.lon!),
                onRefresh: model.onRefresh,
                personPhoto: model.person?.photoUrl,
                name: model.person?.name ?? '',
                deviceName: 'Часы: ${model.device.type ?? ''}',
                lastActiveTime: model.device.states!.coordTs,
                battaryPercent: model.device.batteryPercent,
                active: model.device.online,
                onMap: model.onMap,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  const Divider(height: 1, indent: 0),
                  AutoScrollTag(
                    key: const ValueKey(0),
                    controller: model.controller,
                    index: 0,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: const [AppShadows.dashboard],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AppIconButton(
                                  title: 'Позвонить',
                                  icon: Icons.phone,
                                  onTap: model.onPhoneCallTap,
                                ),
                                AppIconButton(
                                  title: 'Написать',
                                  icon: Icons.chat_bubble,
                                  onTap: model.onMessageTap,
                                ),
                                AppIconButton(
                                  title: 'Видеозвонок',
                                  icon: Icons.videocam,
                                  onTap: model.onVideoCallTap,
                                ),
                                AppIconButton(
                                  title: 'Ещё',
                                  icon: Icons.pending,
                                  onTap: model.onMoreTap,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AutoScrollTag(
                    key: const ValueKey(1),
                    controller: model.controller,
                    index: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Tappable(
                        onPressed: model.onHealthTap,
                        child: HealthCard(
                          currentSteps: model.device.states?.totalStepCount ?? 0,
                          needSteps: model.device.deviceProps?.dailyStepsGoal ?? 0,
                          cal: model.activity?.days?.first.kcal ?? 0,
                          pulse: model.pulse?.avgPulse?.toInt() ?? 0,
                          maxPulse: model.maxPulse,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AutoScrollTag(
                    key: const ValueKey(2),
                    controller: model.controller,
                    index: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GeoZonesCard(
                        geozones: model.geozones,
                        onGeozonesTap: model.onGeozonesTap,
                        name: model.person!.name!,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AutoScrollTag(
                    key: const ValueKey(3),
                    controller: model.controller,
                    index: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ActionsCard(
                        onTakePhotoTap: model.onTakePhotoTap,
                        onSearchTap: model.onSearchTap,
                        onMovingTap: model.onMovingTap,
                        onGeozonesTap: model.onGeozonesTap,
                        onGalleryTap: model.onGalleryTap,
                        onDoNotDisturbTap: model.onDoNotDistrubTap,
                        onBackCallTap: model.onBackCallTap,
                        onAlarmClocksTap: model.onAlarmClockTap,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AutoScrollTag(
                    key: const ValueKey(4),
                    controller: model.controller,
                    index: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DeviceCard(
                          onOffTap: () => model.onOffTap(context),
                          onRebootTap: () => model.onRebootTap(context),
                          onSettingsTap: model.onSettingsTap),
                    ),
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ],
          ),
        );
        // return AppBarWithMap(
        //   isBusy: model.isBusy,
        //   map: IgnorePointer(
        //     child: Stack(
        //       children: [
        //         GoogleMap(
        //           myLocationButtonEnabled: false,
        //           tiltGesturesEnabled: false,
        //           zoomGesturesEnabled: false,
        //           zoomControlsEnabled: false,
        //           liteModeEnabled: true,
        //           scrollGesturesEnabled: false,
        //           rotateGesturesEnabled: false,
        //           mapToolbarEnabled: false,
        //           compassEnabled: false,
        //           initialCameraPosition: CameraPosition(
        //             target: LatLng(
        //                 (model.device.lat ?? 0) != 0
        //                     ? model.device.lat!
        //                     : 51.84073192719293,
        //                 (model.device.lon ?? 0) != 0
        //                     ? model.device.lon!
        //                     : 107.63126545640826),
        //             zoom: 15,
        //           ),
        //         ),
        //         Align(
        //           alignment: Alignment.topCenter,
        //           child: Container(
        //             margin: const EdgeInsets.only(top: kToolbarHeight * 3 - 55),
        //             child: MapMarker(photoUrl: model.person?.photoUrl),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        //   body: ,
        // );
      },
    );
  }
}
