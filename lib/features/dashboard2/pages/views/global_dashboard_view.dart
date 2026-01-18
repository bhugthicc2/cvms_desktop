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
          // STATS SECTION (lightweight)
          BlocBuilder<DashboardCubit, DashboardState>(
            buildWhen:
                (prev, curr) =>
                    prev.totalEntriesExits != curr.totalEntriesExits ||
                    prev.totalVehicles != curr.totalVehicles ||
                    prev.totalPendingViolations !=
                        curr.totalPendingViolations ||
                    prev.totalViolations != curr.totalViolations,
            builder: (context, state) {
              return GlobalStatsCardSection(
                statsCard1Label: 'Total Violations',
                statsCard1Value: state.totalViolations,
                statsCard2Label:
                    'Pending Violations', //realtime data retrieval based on collection field step 13
                statsCard2Value: state.totalPendingViolations,
                statsCard3Label: 'Total Vehicles',
                statsCard3Value: state.totalVehicles,
                statsCard4Label: 'Total Entries/Exits',
                statsCard4Value:
                    state
                        .totalEntriesExits, // Realtime implementation step 22 ),
              );
            },
          ),

          // CHARTS SECTION (heavy)
          BlocBuilder<DashboardCubit, DashboardState>(
            buildWhen:
                (prev, curr) =>
                    prev.vehicleDistribution !=
                    curr.vehicleDistribution, //rebuild only when data has changes
            builder: (context, state) {
              return GlobalChartsSection(
                vehicleDistribution:
                    state
                        .vehicleDistribution, //real time grouped aggregation impl step 11
                yearLevelBreakdown: MockDashboardData.yearLevelBreakdown,
                studentWithMostViolations: MockDashboardData.studentViolations,
                cityBreakdown: MockDashboardData.cityBreakdown,
                violationDistribution: MockDashboardData.violationDistribution,
                vehicleLogsDistributionPerCollege:
                    MockDashboardData.vehicleLogsDistributionPerCollege,
                violationDistributionPerCollege:
                    MockDashboardData.violationDistributionPerCollege,
              );
            },
          ),
        ],
      ),
    );
  }
}
