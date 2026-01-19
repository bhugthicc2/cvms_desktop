import 'package:cvms_desktop/core/widgets/app/custom_alert_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_date_filter.dart';
import 'package:cvms_desktop/features/dashboard2/bloc/global/global_dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard2/models/time_grouping.dart';
import 'package:cvms_desktop/features/dashboard2/utils/dynamic_title_formatter.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/stats/global_stats_card_section.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/charts/global_charts_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalDashboardView extends StatefulWidget {
  final String? currentTimeRange;
  const GlobalDashboardView({super.key, this.currentTimeRange = '7 days'});

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
      context.read<GlobalDashboardCubit>().watchFleetLogsTrend(
        start: DateTime.now().subtract(const Duration(days: 6)), // last 7 days
        end: DateTime.now(), // today
        grouping: TimeGrouping.day, // daily buckets
      );
    });
  }

  void _onTimeRangeChanged(String selectedRange) {
    // Update time range in cubit state
    context.read<GlobalDashboardCubit>().updateTimeRange(selectedRange);

    DateTime endDate = DateTime.now();
    DateTime startDate;

    switch (selectedRange) {
      case '7 days':
        startDate = endDate.subtract(Duration(days: 7));
        break;
      case '30 days':
        startDate = endDate.subtract(Duration(days: 30));
        break;
      case 'Month':
        startDate = DateTime(endDate.year, endDate.month, 1);
        break;
      case 'Year':
        startDate = DateTime(endDate.year, 1, 1);
        break;
      case 'Custom':
        // Trigger custom date picker
        _showCustomDatePicker();
        return;
      default:
        return;
    }

    // Apply the selected date range to the data (e.g., fleet logs, charts)
    context.read<GlobalDashboardCubit>().watchFleetLogsTrend(
      start: startDate,
      end: endDate,
      grouping: TimeGrouping.day, // or whatever your default grouping is
    );
  }

  void _showCustomDatePicker() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomAlertDialog(
          title: 'Select Date Range',
          child: CustomDateFilter(
            onApply: (period) {
              if (period != null) {
                // Update current time range to reflect custom selection
                context.read<GlobalDashboardCubit>().updateTimeRange('Custom');

                // Use the original context to access the cubit
                context.read<GlobalDashboardCubit>().watchFleetLogsTrend(
                  start: period.start,
                  end: period.end,
                  grouping: TimeGrouping.day,
                );
              }
              Navigator.of(dialogContext).pop(); // Close the date picker dialog
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // STATS SECTION (lightweight)
          BlocBuilder<GlobalDashboardCubit, GlobalDashboardState>(
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
          BlocBuilder<GlobalDashboardCubit, GlobalDashboardState>(
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
                onTimeRangeChanged: (value) {
                  _onTimeRangeChanged(value);
                },

                lineChartTitle: DynamicTitleFormatter().getDynamicTitle(
                  'Vehicle logs for ',
                  state.currentTimeRange,
                ),
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
