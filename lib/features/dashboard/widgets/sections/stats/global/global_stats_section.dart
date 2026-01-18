import 'package:flutter/material.dart';
import '../../../../models/fleet_summary.dart';
import 'global_stats_card_section.dart';

/// Global Stats Section - Displays fleet-wide statistics including:
class GlobalStatsSection extends StatelessWidget {
  const GlobalStatsSection({super.key, required this.summary});

  final FleetSummary summary;

  @override
  Widget build(BuildContext context) {
    return GlobalStatsCardSection(
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
