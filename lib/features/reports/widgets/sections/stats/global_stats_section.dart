import 'package:flutter/material.dart';
import '../../../models/fleet_summary.dart';
import 'global_stats_card_section.dart';

/// Global Stats Section - Displays fleet-wide statistics including:
class GlobalStatsSection extends StatelessWidget {
  const GlobalStatsSection({
    super.key,
    required this.summary,
    this.onStatCard1Click,
    this.onStatCard2Click,
    this.onStatCard3Click,
    this.onStatCard4Click,
  });

  final FleetSummary summary;
  final VoidCallback? onStatCard1Click;
  final VoidCallback? onStatCard2Click;
  final VoidCallback? onStatCard3Click;
  final VoidCallback? onStatCard4Click;

  @override
  Widget build(BuildContext context) {
    return GlobalStatsCardSection(
      onStatCard1Click: onStatCard1Click,
      onStatCard2Click: onStatCard2Click,
      onStatCard3Click: onStatCard3Click,
      onStatCard4Click: onStatCard4Click,
      statsCard1Label: 'Total Violations',
      statsCard1Value: summary.totalViolations,
      statsCard2Label: 'Pending Violations',
      statsCard2Value: summary.activeViolations,
      statsCard3Label: 'Total Vehicles',
      statsCard3Value: summary.totalVehicles,
      statsCard4Label: 'Total Entries/Exits',
      statsCard4Value: summary.totalEntriesExits,
    );
  }
}
