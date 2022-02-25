import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

import 'device_map_viewmodel.dart';

class DeviceMapViewRoute extends CupertinoPageRoute {
  DeviceMapViewRoute(DeviceModel device)
      : super(
            builder: (context) => const _DeviceMapView(),
            settings: RouteSettings(arguments: device));
}

class _DeviceMapView extends StatelessWidget {
  const _DeviceMapView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeviceMapViewModel>.reactive(
      viewModelBuilder: () => DeviceMapViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        if (model.isBusy)
          return Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: AppColors.white,
              ),
              const LoadingScreen(),
            ],
          );
        return Scaffold(
          backgroundColor: AppColors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: model.animateSelf,
            mini: true,
            backgroundColor: const Color(0xB3373C46),
            foregroundColor: AppColors.white,
            child: const Icon(Icons.gps_fixed_outlined, size: 30),
          ),
          body: Stack(
            children: [
              GoogleMap(
                onMapCreated: (controller) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    model.setController(controller);
                  });
                },
                compassEnabled: false,
                indoorViewEnabled: true,
                mapToolbarEnabled: false,
                myLocationEnabled: true,
                tiltGesturesEnabled: false,
                zoomControlsEnabled: false,
                rotateGesturesEnabled: false,
                myLocationButtonEnabled: false,
                markers: model.markers,
                initialCameraPosition: CameraPosition(
                  target: model.initialPosition,
                  zoom: 12,
                ),
              ),
              Positioned(
                left: 16,
                top: 22 + MediaQuery.of(context).viewPadding.top,
                child: FloatingActionButton(
                  heroTag: 'back_button',
                  onPressed: () => Navigator.pop(context),
                  mini: true,
                  backgroundColor: const Color(0xB3373C46),
                  foregroundColor: AppColors.white,
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 18,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
