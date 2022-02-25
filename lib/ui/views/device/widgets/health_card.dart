import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_card.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HealthCard extends StatelessWidget {
  const HealthCard(
      {required this.cal,
      required this.currentSteps,
      required this.needSteps,
      required this.pulse,
      required this.maxPulse});
  final int currentSteps;
  final int needSteps;
  final double cal;
  final int pulse;
  final int maxPulse;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Здоровье', style: AppStyles.titleCard),
              const Icon(
                Icons.navigate_next,
                size: 28,
                color: AppColors.gray100,
              )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircularPercentIndicator(
                radius: 56,
                lineWidth: 6,
                percent: currentSteps / needSteps <= 1 ? currentSteps / needSteps : 1,
                center: const Icon(
                  Icons.directions_walk,
                  color: AppColors.green,
                  size: 28,
                ),
                backgroundColor: AppColors.gray10,
                progressColor: AppColors.green,
                circularStrokeCap: CircularStrokeCap.butt,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '$currentSteps шагов',
                      style: AppStyles.healthTileTiltle,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            needSteps - currentSteps >= 0
                                ? 'осталось ${needSteps - currentSteps} шагов до цели'
                                : 'Цель выполнена',
                            style: AppStyles.healthTileSubtitle,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          const Divider(
            height: 32,
            indent: 72,
          ),
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentYellow.withOpacity(0.15)),
                child: const SizedBox(
                  height: 56,
                  width: 56,
                  child: Icon(
                    Icons.local_fire_department,
                    color: AppColors.accentYellow,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$cal ккал.',
                      style: AppStyles.healthTileTiltle,
                    ),
                    const SizedBox(height: 8),
                    AutoSizeText(
                      'потрачено',
                      style: AppStyles.healthTileSubtitle,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            height: 32,
            indent: 72,
          ),
          Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.red.withOpacity(0.15)),
                child: const SizedBox(
                  height: 56,
                  width: 56,
                  child: Icon(
                    Icons.directions_walk,
                    color: AppColors.red,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$pulse уд./мин',
                      style: AppStyles.healthTileTiltle,
                    ),
                    const SizedBox(height: 8),
                    AutoSizeText(
                      'максимум сегодня $maxPulse уд./мин',
                      style: AppStyles.healthTileSubtitle,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
