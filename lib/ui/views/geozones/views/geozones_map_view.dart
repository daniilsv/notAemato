import 'package:notaemato/data/model/geozone.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/loading_screen.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

import 'geozones_map_viewmodel.dart';

class GeozonesMapViewRoute extends CupertinoPageRoute<GeozoneModel> {
  GeozonesMapViewRoute({GeozoneModel? geozone})
      : super(
            builder: (context) => const GeozonesMapView(),
            settings: RouteSettings(arguments: geozone));
}

class GeozonesMapView extends StatelessWidget {
  const GeozonesMapView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RadiusGeozoneViewModel>.reactive(
      viewModelBuilder: () => RadiusGeozoneViewModel(context),
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
              OverflowBox(
                maxHeight: MediaQuery.of(context).size.height +
                    (model.initial == null ? 0 : (model.initial?.id == null ? 220 : 72)),
                alignment: Alignment.bottomCenter,
                child: GoogleMap(
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
                    zoom: 16,
                  ),
                  circles: model.circles,
                  onTap: model.isEdit || model.isNew
                      ? (latlng) => model.onMapTap(latlng)
                      : null,
                ),
              ),
              if (model.isEdit || model.isNew)
                Positioned(
                  right: 16,
                  top: 10 + MediaQuery.of(context).viewPadding.top,
                  child: FloatingActionButton(
                    heroTag: 'animate_self',
                    onPressed: model.animateSelf,
                    mini: true,
                    backgroundColor: const Color(0xB3373C46),
                    foregroundColor: AppColors.white,
                    child: const Icon(
                      Icons.gps_fixed_outlined,
                      size: 30,
                    ),
                  ),
                ),
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
                bottom: 24,
                left: 24,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 48,
                  child: Column(
                    children: [
                      if (model.isNew) ...[
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                            boxShadow: const [AppShadows.dashboard],
                          ),
                          child: TextField(
                            controller: model.textController,
                            onChanged: (t) => model.onChanged(),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: 'Название',
                              border: InputBorder.none,
                              labelStyle: AppStyles.textLabel,
                              contentPadding: const EdgeInsets.symmetric(vertical: 4),
                              suffixIconConstraints: const BoxConstraints(maxWidth: 36),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (model.isEdit || model.isNew) ...[
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                              boxShadow: const [AppShadows.dashboard],
                            ),
                            child: Row(
                              children: [
                                Text('Радиус'),
                                Expanded(
                                  child: Slider(
                                      inactiveColor: AppColors.gray10,
                                      min: 50,
                                      max: 300,
                                      value: model.geozone!.radius!.toDouble(),
                                      onChanged: (newVal) => model.setRadius(newVal)),
                                ),
                                Text('${model.geozone!.radius!.floor()}м'),
                              ],
                            )),
                      ],
                      if (model.isNew) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: model.enable ? AppColors.primary : AppColors.gray70,
                            boxShadow: const [AppShadows.dashboard],
                          ),
                          child: Tappable(
                            onPressed: model.enable ? model.onSaveTap : null,
                            child: Center(
                              child: Text(
                                'Сохранить',
                                style: AppStyles.whiteTextButton,
                              ),
                            ),
                          ),
                        ),
                      ]
                    ],
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
