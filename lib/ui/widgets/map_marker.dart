import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/theme/triangle.dart';
import 'package:notaemato/ui/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MapMarker extends StatelessWidget {
  const MapMarker({
    required this.photoUrl,
    Key? key,
  }) : super(key: key);

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: const BoxDecoration(
              boxShadow: [AppShadows.dashboard],
              shape: BoxShape.circle,
              color: AppColors.white),
          child: Center(
            child: SizedBox(
              height: 40,
              width: 40,
              child: Avatar(photoUrl: photoUrl),
            ),
          ),
        ),
        ClipPath(
          clipper: TriangleClipper(),
          child: Container(
            decoration: const BoxDecoration(
                boxShadow: [AppShadows.marker], color: AppColors.white),
            height: 7,
            width: 8,
          ),
        )
      ],
    );
  }
}
