import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/dashboard/widgets/components/stats/stats_card_section.dart';
import 'package:flutter/material.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: StatsCardSection(
        statsCard1Label: statsCard1Label,
        statsCard1Value: statsCard1Value,
        statsCard2Label: statsCard2Label,
        statsCard2Value: statsCard2Value,
        statsCard3Label: statsCard3Label,
        statsCard3Value: statsCard3Value,
        statsCard4Label: statsCard4Label,
        statsCard4Value: statsCard4Value,
      ),
    );
  }
}
