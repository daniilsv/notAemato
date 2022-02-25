import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_header_action.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'geozones_viewmodel.dart';

class GeozonesViewRoute extends CupertinoPageRoute<DeviceModel> {
  GeozonesViewRoute({DeviceModel? device})
      : super(
            builder: (context) => const GeozonesView(),
            settings: RouteSettings(arguments: device));
}

class GeozonesView extends StatelessWidget {
  const GeozonesView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GeozonesViewModel>.reactive(
      viewModelBuilder: () => GeozonesViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          title: 'Геозоны',
          actions: [AppHeaderAction(onTap: model.onMapTap, icon: Icons.map)],
          body: Column(
            children: [
              Expanded(
                  child: ListView.separated(
                padding: const EdgeInsets.all(0),
                separatorBuilder: (context, index) =>
                    const Divider(indent: 16, height: 32),
                itemCount: model.geozones.length,
                itemBuilder: (context, index) => Tappable(
                  onPressed: () => model.onGeozoneTap(model.geozones[index]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            model.geozones[index].name!,
                            style: AppStyles.textTile,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            color: AppColors.lightText, size: 24),
                      ],
                    ),
                  ),
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: AppButton(
                  text: 'Добавить геозону',
                  onPressed: model.onAddGeozoneTap,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
