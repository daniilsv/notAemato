import 'package:notaemato/app/locator.dart';
import 'package:notaemato/data/api/socket.dart';
import 'package:notaemato/data/model/geozone.dart';
import 'package:notaemato/data/services/geozones.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

import 'geozones_map_view.dart';

class GeozoneViewModel extends BaseViewModel {
  GeozoneViewModel(BuildContext context) {
    geozone = ModalRoute.of(context)!.settings.arguments as GeozoneModel?;
    navigator = Navigator.of(context);
    rootNavigator = Navigator.of(context, rootNavigator: true);
  }
  // Services
  final SocketApi api = locator<SocketApi>();
  final GeozonesService geozonesService = locator<GeozonesService>();
  late NavigatorState navigator;
  late NavigatorState rootNavigator;
  bool isEdit = false;
  final focus = FocusNode();

  // Constants
  GeozoneModel? geozone;
  Set<Circle> get circle => {
        Circle(
            circleId: const CircleId('0'),
            radius: geozone!.radius!.toDouble(),
            center: geozone!.center!,
            strokeWidth: 1,
            fillColor: AppColors.primary.withOpacity(0.2),
            strokeColor: AppColors.primary)
      };

  // Controllers
  late GoogleMapController controller;
  final textController = TextEditingController();
  // Variables

  // Logic

  Future onReady() async {
    //
  }

  Future<void> onEditTap() async {
    final ret = await rootNavigator.push(GeozonesMapViewRoute(geozone: geozone));
    geozone = ret;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: ret!.center!, zoom: 15)));
    notifyListeners();
  }

  void onRenameTap() {
    isEdit = true;
    textController.text = geozone!.name!;
    focus.requestFocus();
    notifyListeners();
  }

  Future<void> onSaveNameTap() async {
    geozone!.name = textController.text;
    setBusy(true);
    await api.upsertGeozone(geozone!);
    await geozonesService.update(force: true);
    isEdit = false;
    setBusy(false);
  }

  // ignore: use_setters_to_change_properties
  void setController(GoogleMapController controller) {
    this.controller = controller;
  }

  Future<void> onDeleteTap() async {
    final ret = await api.deleteGeozone(geozone!.id);
    if (ret == null) return;
    geozonesService.update(force: true);
    navigator.pop();
  }
}
