import 'package:notaemato/data/model/geozone.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_card.dart';
import 'package:notaemato/ui/widgets/app_icon_button.dart';
import 'package:notaemato/ui/widgets/map_marker.dart';
import 'package:notaemato/ui/widgets/app_bar_with_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

import 'geozone_viewmodel.dart';

class GeozoneViewRoute extends CupertinoPageRoute<GeozoneModel> {
  GeozoneViewRoute({GeozoneModel? geozone})
      : super(
            builder: (context) => const GeozoneView(),
            settings: RouteSettings(arguments: geozone));
}

class GeozoneView extends StatelessWidget {
  const GeozoneView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GeozoneViewModel>.reactive(
      viewModelBuilder: () => GeozoneViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppBarWithMap(
          isBusy: model.isBusy,
          map: IgnorePointer(
            child: Stack(
              children: [
                GoogleMap(
                    onMapCreated: model.setController,
                    circles: model.circle,
                    myLocationButtonEnabled: false,
                    tiltGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    zoomControlsEnabled: false,
                    // liteModeEnabled: true,
                    scrollGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    mapToolbarEnabled: false,
                    compassEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: model.geozone!.center!,
                      zoom: 15,
                    )),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      margin: const EdgeInsets.only(top: kToolbarHeight * 3 - 55),
                      child: const MapMarker(
                        photoUrl: null,
                      )),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AppCard(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: model.isEdit ? TextField(
                            controller: model.textController,
                            focusNode: model.focus,
                          ) : Text(model.geozone!.name!, style: AppStyles.titleCard),
                        ),
                        Divider(
                          height: 32,
                          indent: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: model.isEdit ? AppButton(text: 'Сохранить', onPressed: model.onSaveNameTap) : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: AppIconButton(
                                  title: 'Переименовать',
                                  icon: Icons.mode_edit_outlined,
                                  onTap: model.onRenameTap,
                                ),
                              ),
                              Expanded(
                                child: AppIconButton(
                                    title: 'Изменить',
                                    icon: Icons.tune_rounded,
                                    onTap: model.onEditTap),
                              ),
                              Expanded(
                                child: AppIconButton(
                                    title: 'Удалить', icon: Icons.delete, onTap: model.onDeleteTap),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                const SizedBox(height: 16),
                // AppCard(child: Container()),
                // const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
