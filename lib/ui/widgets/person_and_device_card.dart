import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/widgets/device_card_tile.dart';
import 'package:notaemato/ui/widgets/person_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notaemato/ui/theme/theme.dart';

import 'app_card.dart';

class PersonAndDeviceCard extends StatelessWidget {
  const PersonAndDeviceCard({
    this.onMenu,
    this.device,
    this.name,
    this.photoUrl,
  });
  final VoidCallback? onMenu;
  final DeviceModel? device;
  final String? name;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          PersonTile(
            onMenu: onMenu,
            title: name,
            photoUrl: photoUrl,
          ),
          if (device != null) ...[
            const Divider(
              color: AppColors.gray30,
            ),
            DeviceTile(
              device: device,
              isButton: true,
            )
          ]
          // if (device == null)
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text('Нет привязанных устройств'),
          //   )
        ],
      ),
    );
  }
}
