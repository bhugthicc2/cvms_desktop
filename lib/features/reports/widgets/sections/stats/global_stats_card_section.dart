import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class GlobalStatsCardSection extends StatelessWidget {
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
  //callbacks
  final VoidCallback? onStatCard1Click;
  final VoidCallback? onStatCard2Click;
  final VoidCallback? onStatCard3Click;
  final VoidCallback? onStatCard4Click;
  const GlobalStatsCardSection({
    super.key,
    required this.statsCard1Label,
    required this.statsCard2Label,
    required this.statsCard3Label,
    required this.statsCard4Label,
    required this.statsCard1Value,
    required this.statsCard2Value,
    required this.statsCard3Value,
    required this.statsCard4Value,
    this.onStatCard1Click,
    this.onStatCard2Click,
    this.onStatCard3Click,
    this.onStatCard4Click,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatsCard(
            onClick: onStatCard1Click,
            angle: 0,
            color: AppColors.white,
            icon: PhosphorIconsBold.calendarMinus,
            label: statsCard1Label,
            value: statsCard1Value,
            gradient: AppColors.blueViolet,
            iconColor: AppColors.donutPink,
          ),
        ),
        Spacing.horizontal(size: AppSpacing.medium),
        Expanded(
          child: StatsCard(
            onClick: onStatCard2Click,
            angle: 0,
            color: AppColors.orange,
            icon: PhosphorIconsBold.calendarMinus,
            label: statsCard2Label,
            value: statsCard2Value,
            gradient: AppColors.yellowOrange,
            iconColor: AppColors.orange,
          ),
        ),
        Spacing.horizontal(size: AppSpacing.medium),
        Expanded(
          child: StatsCard(
            onClick: onStatCard3Click,
            angle: 0,
            color: AppColors.donutBlue,
            icon: PhosphorIconsBold.car,
            label: statsCard3Label,
            value: statsCard3Value,
            gradient: AppColors.purpleBlue,
            iconColor: AppColors.donutBlue,
          ),
        ),
        Spacing.horizontal(size: AppSpacing.medium),
        Expanded(
          child: StatsCard(
            onClick: onStatCard4Click,
            angle: 0,
            color: AppColors.chartGreen,
            icon: PhosphorIconsBold.calendarMinus,
            label: statsCard4Label,
            value: statsCard4Value,
            gradient: AppColors.greenWhite,
            iconColor: AppColors.chartGreen,
          ),
        ),
      ],
    );
  }
}
