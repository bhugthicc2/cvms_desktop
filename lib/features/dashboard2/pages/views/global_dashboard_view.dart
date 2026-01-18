import 'package:cvms_desktop/features/dashboard2/data/mock_data.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/stats/global_stats_card_section.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/charts/global_charts_section.dart';
import 'package:flutter/material.dart';

class GlobalDashboardView extends StatelessWidget {
  const GlobalDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Global Stats Cards
          GlobalStatsCardSection(
            statsCard1Label: 'Total Violations',
            statsCard1Value: MockDashboardData.fleetSummary.totalViolations,
            statsCard2Label: 'Pending Violations',
            statsCard2Value: MockDashboardData.fleetSummary.activeViolations,
            statsCard3Label: 'Total Vehicles',
            statsCard3Value: MockDashboardData.fleetSummary.totalVehicles,
            statsCard4Label: 'Total Entries/Exits',
            statsCard4Value: MockDashboardData.fleetSummary.totalEntriesExits,
          ),

          // Global Charts Section
          GlobalChartsSection(
            summary: MockDashboardData.fleetSummary,
            vehicleDistribution: MockDashboardData.vehicleDistribution,
            yearLevelBreakdown: MockDashboardData.yearLevelBreakdown,
            studentWithMostViolations: MockDashboardData.studentViolations,
            cityBreakdown: MockDashboardData.cityBreakdown,
            violationDistribution: MockDashboardData.violationDistribution,
          ),
        ],
      ),
    );
  }
}
