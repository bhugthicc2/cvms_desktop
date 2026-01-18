import 'package:cvms_desktop/features/dashboard2/bloc/dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard2/data/mock_data.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/stats/global_stats_card_section.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/charts/global_charts_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalDashboardView extends StatelessWidget {
  const GlobalDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Global Stats Cards
          BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              // Realtime implementation step 21
              return GlobalStatsCardSection(
                statsCard1Label: 'Total Violations',
                statsCard1Value: MockDashboardData.fleetSummary.totalViolations,
                statsCard2Label: 'Pending Violations',
                statsCard2Value:
                    MockDashboardData.fleetSummary.activeViolations,
                statsCard3Label: 'Total Vehicles',
                statsCard3Value: MockDashboardData.fleetSummary.totalVehicles,
                statsCard4Label: 'Total Entries/Exits',
                statsCard4Value:
                    state.totalEntriesExits, // Realtime implementation step 22
              );
            },
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
