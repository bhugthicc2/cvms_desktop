import 'package:cvms_desktop/features/dashboard2/bloc/dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard2/models/time_grouping.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/stats/global_stats_card_section.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/charts/global_charts_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalDashboardView extends StatefulWidget {
  const GlobalDashboardView({super.key});

  @override
  State<GlobalDashboardView> createState() => _GlobalDashboardViewState();
}

class _GlobalDashboardViewState extends State<GlobalDashboardView> {
  @override
  void initState() {
    super.initState();

    // step 1: wait for widget to be mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // step 2: ask cubit to start listening
      context.read<DashboardCubit>().watchFleetLogsTrend(
        start: DateTime.now().subtract(const Duration(days: 6)), // last 7 days
        end: DateTime.now(), // today
        grouping: TimeGrouping.day, // daily buckets
      );
    });
  }

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
                    prev.yearLevelBreakdown != curr.yearLevelBreakdown ||
                    prev.vehicleDistribution != curr.vehicleDistribution ||
                    prev.topStudentsWithMostViolations !=
                        curr.topStudentsWithMostViolations ||
                    prev.cityBreakdown != curr.cityBreakdown ||
                    prev.vehicleLogsDistributionPerCollege !=
                        curr.vehicleLogsDistributionPerCollege ||
                    prev.violationDistributionPerCollege !=
                        curr.violationDistributionPerCollege ||
                    prev.violationTypeDistribution !=
                        curr.violationTypeDistribution ||
                    prev.fleetLogsData != curr.fleetLogsData,
            //Flutter, rebuild this widget only if the city breakdown list changed.
            // step 18
            builder: (context, state) {
              return GlobalChartsSection(
                yearLevelBreakdown:
                    state.yearLevelBreakdown, // realtime step 19
                vehicleDistribution: state.vehicleDistribution,
                studentWithMostViolations: state.topStudentsWithMostViolations,
                cityBreakdown: state.cityBreakdown,

                vehicleLogsDistributionPerCollege:
                    state.vehicleLogsDistributionPerCollege,
                violationDistributionPerCollege:
                    state.violationDistributionPerCollege,

                violationTypeDistribution: state.violationTypeDistribution,
                fleetLogsData: state.fleetLogsData, // realtime fleet logs trend
              );
            },
          ),
        ],
      ),
    );
  }
}
