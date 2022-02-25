import 'package:notaemato/data/services/metrica.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/add_device/add_device_view.dart';
import 'package:notaemato/ui/views/general_access/general_access_view.dart';
import 'package:notaemato/ui/views/geozones/geozones_view.dart';
import 'package:notaemato/ui/views/persons_and_devices/person_and_devices_view.dart';
import 'package:notaemato/ui/views/profile/profile_view.dart';
import 'package:notaemato/ui/views/root/root_viewmodel.dart';
import 'package:notaemato/ui/views/test_ui/test_ui_view.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MenuViewRoute extends CupertinoPageRoute {
  MenuViewRoute() : super(builder: (context) => const _MenuView());
}

class _MenuView extends ViewModelWidget<RootViewModel> {
  const _MenuView();
  @override
  Widget build(BuildContext context, RootViewModel model) {
    return AppScaffold(
      implyLeading: false,
      title: Strings.current.menu,
      body: ListView(
        padding: AppPaddings.h24,
        children: [
          ListTile(
            onTap: () {
              MetricaService.event('menu_tap', {'item': 'profile'});
              Navigator.push(context, ProfileViewRoute());
            },
            title: Text(Strings.current.your_account),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              MetricaService.event('menu_tap', {'item': 'persons'});
              Navigator.of(context).push(PersonsAndDevicesViewRoute());
            },
            title: Text(Strings.current.persons_and_devices),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            title: Text(Strings.current.general_access),
            onTap: () {
              MetricaService.event('menu_tap', {'item': 'access'});
              Navigator.of(context).push(GeneralAccessViewRoute());
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if ((model.sharingCount ?? 0) > 0)
                  Chip(
                    label: Text(model.sharingCount.toString()),
                    backgroundColor: AppColors.red,
                    padding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(horizontal: -3.0, vertical: -3.0),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    labelStyle: const TextStyle(color: AppColors.white, fontSize: 16),
                  ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          ListTile(
            title: Text(Strings.current.geozones),
            onTap: () {
              MetricaService.event('menu_tap', {'item': 'geozones'});
              Navigator.of(context).push(GeozonesViewRoute());
            },
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            title: Text(Strings.current.setting_notifications),
            onTap: () {
              MetricaService.event('menu_tap', {'item': 'notifications'});
            },
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(indent: 24, endIndent: 24),
          ListTile(
            title: Text(Strings.of(context).add_device),
            onTap: () {
              MetricaService.event('menu_tap', {'item': 'add_device'});
              Navigator.of(context).push(AddDeviceViewRoute());
            },
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(indent: 24, endIndent: 24),
          ListTile(
            title: const Text('Test UI'),
            onTap: () {
              MetricaService.event('menu_tap', {'item': 'test_ui'});
              Navigator.of(context).push(TestUiViewRoute());
            },
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
