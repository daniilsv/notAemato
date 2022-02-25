import 'dart:math';

import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/device_time_and_battary.dart';
import 'package:notaemato/ui/widgets/map_marker.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeviceViewAppBar extends StatelessWidget {
  const DeviceViewAppBar(
      {required this.mapLocation,
      required this.personPhoto,
      required this.name,
      required this.deviceName,
      required this.lastActiveTime,
      required this.battaryPercent,
      required this.active,
      required this.onMap,
      this.onRefresh});
  final Function? onRefresh;
  final Function? onMap;
  final LatLng mapLocation;
  final String? personPhoto;
  final String name;
  final String deviceName;
  final int? lastActiveTime;
  final int? battaryPercent;
  final bool? active;

  double _getCollapsePadding(double t, FlexibleSpaceBarSettings settings) {
    final double deltaExtent = settings.maxExtent - settings.minExtent;
    return -Tween<double>(begin: 0.0, end: deltaExtent / 4.0).transform(t);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: kToolbarHeight * 6,
      collapsedHeight: kToolbarHeight,
      pinned: true,
      backgroundColor: AppColors.bg,
      iconTheme: const IconThemeData(color: AppColors.gray100),
      brightness: Brightness.light,
      elevation: 4,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final FlexibleSpaceBarSettings settings =
              context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;

          final double deltaExtent = settings.maxExtent - settings.minExtent;

          // 0.0 -> Expanded
          // 1.0 -> Collapsed to toolbar
          final double t =
              (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                  .clamp(0.0, 1.0);

          final double paddingValue = Tween<double>(begin: 16, end: 64).transform(t);

          final double fadeStart = max(0.0, 1.0 - 3 * kToolbarHeight / deltaExtent);
          const double fadeEnd = 1.0;
          final double opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
          final height = settings.maxExtent;

          return SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: _getCollapsePadding(t, settings),
                  left: 0.0,
                  right: 0.0,
                  height: height,
                  child: Opacity(
                    opacity: opacity,
                    child: Tappable(
                      onPressed: () => onMap?.call(),
                      child: Hero(
                        tag: personPhoto ?? '',
                        child: Stack(
                          children: [
                            IgnorePointer(
                              child: GoogleMap(
                                myLocationButtonEnabled: false,
                                tiltGesturesEnabled: false,
                                zoomGesturesEnabled: false,
                                zoomControlsEnabled: false,
                                liteModeEnabled: true,
                                scrollGesturesEnabled: false,
                                rotateGesturesEnabled: false,
                                mapToolbarEnabled: false,
                                compassEnabled: false,
                                initialCameraPosition: CameraPosition(
                                  target: mapLocation,
                                  zoom: 15,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: kToolbarHeight * 3 - 55),
                                child: MapMarker(photoUrl: personPhoto),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  height: kToolbarHeight,
                  left: 0,
                  right: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(left: 16, top: 10),
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gray10,
                    ),
                    child: Material(
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 18,
                          color: AppColors.gray100,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(right: 16, top: 10),
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gray10,
                    ),
                    child: Material(
                      child: InkWell(
                        onTap: () => onRefresh?.call(),
                        child: const Icon(
                          Icons.refresh_rounded,
                          size: 18,
                          color: AppColors.gray100,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: paddingValue,
                  height: kToolbarHeight,
                  width: MediaQuery.of(context).size.width - 2 * paddingValue,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(name, style: AppStyles.titleCard, maxLines: 2),
                            const SizedBox(height: 4),
                            Text(deviceName, style: AppStyles.secondaryCard),
                          ],
                        ),
                      ),
                      Transform(
                        transform: Matrix4.identity().scaled(16 / paddingValue),
                        alignment: Alignment.centerRight,
                        child: Opacity(
                          opacity: opacity,
                          child: DeviceTimeAndBattery(
                            lastActiveTime: lastActiveTime,
                            battaryPercent: battaryPercent,
                            active: active,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Positioned(
                //   bottom: 0,
                //   right: paddingValue,
                //   height: kToolbarHeight,
                //   child: Opacity(
                //     opacity: opacity,
                //     child: DeviceTimeAndBattery(
                //       lastActiveTime: lastActiveTime,
                //       battaryPercent: battaryPercent,
                //       active: active,
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
