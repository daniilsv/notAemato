import 'package:notaemato/data/model/history.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/loading_screen.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

import 'history_map_viewmodel.dart';

class HistoryMapViewRoute extends CupertinoPageRoute {
  HistoryMapViewRoute({List<HistoryPoint>? points})
      : super(
            builder: (context) => const HistoryMapView(),
            settings: RouteSettings(arguments: points));
}

class HistoryMapView extends StatelessWidget {
  const HistoryMapView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HistoryMapViewModel>.reactive(
      viewModelBuilder: () => HistoryMapViewModel(context),
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
          body: Stack(
            clipBehavior: Clip.antiAlias,
            fit: StackFit.expand,
            alignment: AlignmentDirectional.bottomCenter,
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
                polylines: model.polylines,
                initialCameraPosition: CameraPosition(
                  target: model.initialPosition,
                  zoom: 16,
                ),
              ),
              // Positioned(
              //   right: 16,
              //   top: 10 + MediaQuery.of(context).viewPadding.top,
              //   child: FloatingActionButton(
              //     heroTag: 'animate_self',
              //     onPressed: model.animateSelf,
              //     mini: true,
              //     backgroundColor: const Color(0xB3373C46),
              //     foregroundColor: AppColors.white,
              //     child: const Icon(
              //       Icons.gps_fixed_outlined,
              //       size: 30,
              //     ),
              //   ),
              // ),
              Positioned(
                left: 16,
                top: 10 + MediaQuery.of(context).viewPadding.top,
                child: FloatingActionButton(
                  heroTag: 'back_button',
                  onPressed: model.onPop,
                  mini: true,
                  backgroundColor: const Color(0xB3373C46),
                  foregroundColor: AppColors.white,
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 18,
                  ),
                ),
              ),
              Positioned(
                top: 10 + MediaQuery.of(context).viewPadding.top,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [AppShadows.marker]),
                    child: Column(
                      children: [
                        Text(
                          model.date,
                          style: AppStyles.titleCard,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text('${model.getSteps()} шагов',
                            style: AppStyles.textTileCaption)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
