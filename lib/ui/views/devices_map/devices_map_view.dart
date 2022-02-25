import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

import 'devices_map_viewmodel.dart';

class DevicesMapViewRoute extends CupertinoPageRoute {
  DevicesMapViewRoute() : super(builder: (context) => const _DevicesMapView());
}

class _DevicesMapView extends StatelessWidget {
  const _DevicesMapView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DevicesMapViewModel>.reactive(
      viewModelBuilder: () => DevicesMapViewModel(),
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
