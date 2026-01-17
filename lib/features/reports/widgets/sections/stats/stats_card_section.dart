import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StatsCardSection extends StatelessWidget {
  //labels
  final String statsCard1Label;
  final String statsCard2Label;
  final String statsCard3Label;
  final String statsCard4Label;
  //values
  final int statsCard1Value;
  final int statsCard2Value;
  final int statsCard3Value;
  final int statsCard4Value;
  const StatsCardSection({
    super.key,
    required this.statsCard1Label,
    required this.statsCard2Label,
    required this.statsCard3Label,
    required this.statsCard4Label,
    required this.statsCard1Value,
    required this.statsCard2Value,
    required this.statsCard3Value,
    required this.statsCard4Value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            height: 110,
            child: Row(
              children: [
                Expanded(
                  child: StatsCard(
                    height: 110,
                    angle: 0,
                    color: AppColors.white,
                    icon: PhosphorIconsBold.calendarMinus,
                    label: statsCard1Label,
                    value: statsCard1Value,
                    gradient: AppColors.greenWhite,
                    iconColor: AppColors.chartGreenv2,
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(
                  child: StatsCard(
                    height: 110,
                    angle: 0,
                    color: AppColors.orange,
                    icon: PhosphorIconsBold.calendarMinus,
                    label: statsCard2Label,
                    value: statsCard2Value,
                    gradient: AppColors.yellowOrange,
                    iconColor: AppColors.orange,
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacing.vertical(size: AppSpacing.medium),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: StatsCard(
                  height: 110,
                  angle: 0,
                  color: AppColors.white,
                  icon: PhosphorIconsBold.calendarMinus,
                  label: statsCard3Label,
                  value: statsCard3Value,
                  gradient: AppColors.purpleBlue,
                  iconColor: AppColors.primary,
                ),
              ),
              Spacing.horizontal(size: AppSpacing.medium),
              Expanded(
                child: StatsCard(
                  height: 110,
                  angle: 0,
                  color: AppColors.white,
                  icon: PhosphorIconsBold.calendarMinus,
                  label: statsCard4Label,
                  value: statsCard4Value,
                  gradient: AppColors.pinkWhite,
                  iconColor: AppColors.donutPink,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
