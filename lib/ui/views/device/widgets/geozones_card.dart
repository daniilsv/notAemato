import 'package:notaemato/data/model/geozone.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_card.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:flutter/material.dart';

class GeoZonesCard extends StatelessWidget {
  const GeoZonesCard({required this.geozones, required this.onGeozonesTap, required this.name});
  final List<GeozoneModel>? geozones;
  final VoidCallback onGeozonesTap;
  final String name;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Геозоны', style: AppStyles.titleCard),
          const SizedBox(height: 16),
          if (geozones!.isEmpty || geozones == null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Настройте геозоны и получайте уведомления, когда $name посещает или покидаего геозону.',
                textAlign: TextAlign.center,
                style: AppStyles.secondaryCard.copyWith(height: 1.4),
              ),
            ),
          if (geozones!.isNotEmpty)
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: geozones!.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 28,
                      color: AppColors.gray80,
                    ),
                    const SizedBox(width: 16),
                    Text(geozones![index].name!)
                  ],
                ),
              ),
            ),
          Tappable(
            onPressed: onGeozonesTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Настроить',
                  style: AppStyles.textButton,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
