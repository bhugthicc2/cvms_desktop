import 'package:cvms_desktop/core/widgets/app/custom_alert_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_date_filter.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard/global/global_dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/time_grouping.dart';
import 'package:cvms_desktop/features/dashboard/utils/dynamic_title_formatter.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/stats/global_stats_card_section.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/charts/global_charts_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalDashboardView extends StatefulWidget {
  final String? currentTimeRange;
  final double hoverDy;
  // Stats card onclick handlers
  final VoidCallback? onTotalViolationsClick;
  final VoidCallback? onPendingViolationsClick;
  final VoidCallback? onTotalVehiclesClick;
  final VoidCallback? onTotalEntriesExitsClick;
  // Chart view tap handlers
  final VoidCallback? onVehicleDistributionTap;
  final VoidCallback? onYearLevelBreakdownTap;
  final VoidCallback? onTopViolatorsTap;
  final VoidCallback? onTopCitiesTap;
  final VoidCallback? onVehicleLogsDistributionTap;
  final VoidCallback? onViolationDistributionTap;
  final VoidCallback? onTopViolationsTap;
  final VoidCallback? onFleetLogsTap;
  final VoidCallback? onViolationTrendTap;

  const GlobalDashboardView({
    super.key,
    this.currentTimeRange = '7 days',
    this.hoverDy = -0.01,
    this.onTotalViolationsClick,
    this.onPendingViolationsClick,
    this.onTotalVehiclesClick,
    this.onTotalEntriesExitsClick,
    this.onVehicleDistributionTap,
    this.onYearLevelBreakdownTap,
    this.onTopViolatorsTap,
    this.onTopCitiesTap,
    this.onVehicleLogsDistributionTap,
    this.onViolationDistributionTap,
    this.onTopViolationsTap,
    this.onFleetLogsTap,
    this.onViolationTrendTap,
  });

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
      //for violation trend
      context.read<GlobalDashboardCubit>().watchViolationTrend(
        start: DateTime.now().subtract(const Duration(days: 6)), // last 7 days
        end: DateTime.now(), // today
        grouping: TimeGrouping.day, // daily buckets
      );
    });
  }

  void _onFleetLogsTimeRangeChanged(String selectedFleetLogsTimeRange) {
    // Update vehicle logs time range in cubit state
    context.read<GlobalDashboardCubit>().updateVehicleLogsTimeRange(
      selectedFleetLogsTimeRange,
    );

    DateTime endDate = DateTime.now();
    DateTime startDate;

    switch (selectedFleetLogsTimeRange) {
      case '7 days':
        startDate = endDate.subtract(Duration(days: 6));
        break;
      case '30 days':
        startDate = endDate.subtract(Duration(days: 29));
        break;
      case 'Month':
        startDate = DateTime(endDate.year, endDate.month, 1);
        break;
      case 'Year':
        startDate = DateTime(endDate.year, 1, 1);
        break;
      case 'Custom':
        // Trigger custom date picker
        _showCustomVehicleLogsTrendDatePicker();
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

  void _onViolationTrendTimeRangeChanged(
    String selectedViolationTrendTimeRange,
  ) {
    // Update violation trend time range in cubit state
    context.read<GlobalDashboardCubit>().updateViolationTrendTimeRange(
      selectedViolationTrendTimeRange,
    );

    DateTime endDate = DateTime.now();
    DateTime startDate;

    switch (selectedViolationTrendTimeRange) {
      case '7 days':
        startDate = endDate.subtract(Duration(days: 6));
        break;
      case '30 days':
        startDate = endDate.subtract(Duration(days: 29));
        break;
      case 'Month':
        startDate = DateTime(endDate.year, endDate.month, 1);
        break;
      case 'Year':
        startDate = DateTime(endDate.year, 1, 1);
        break;
      case 'Custom':
        // Trigger custom date picker
        _showCustomViolationTrendDatePicker();
        return;
      default:
        return;
    }

    //Violation trend
    context.read<GlobalDashboardCubit>().watchViolationTrend(
      start: startDate,
      end: endDate,
      grouping: TimeGrouping.day,
    );
  }

  void _showCustomVehicleLogsTrendDatePicker() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomAlertDialog(
          title: 'Select Date Range',
          child: CustomDateFilter(
            onApply: (period) {
              if (period != null) {
                // Update vehicle logs time range to reflect custom selection
                context.read<GlobalDashboardCubit>().updateVehicleLogsTimeRange(
                  'Custom',
                );

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

  void _showCustomViolationTrendDatePicker() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomAlertDialog(
          title: 'Select Date Range',
          child: CustomDateFilter(
            onApply: (period) {
              if (period != null) {
                // Update violation trend time range to reflect custom selection
                context
                    .read<GlobalDashboardCubit>()
                    .updateViolationTrendTimeRange('Custom');

                //Violation Trend
                context.read<GlobalDashboardCubit>().watchViolationTrend(
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
    return BlocBuilder<GlobalDashboardCubit, GlobalDashboardState>(
      builder: (context, state) {
        if (state.loading) {
          Center(child: Text('Loading please wait...'));
        }
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
                    statsCard3Label: 'Total Vehicles  Registered',
                    statsCard3Value: state.totalVehicles,
                    statsCard4Label: 'Total Entries/Exits',
                    statsCard4Value:
                        state
                            .totalEntriesExits, // Realtime implementation step 22 ),
                    hoverDy: widget.hoverDy,
                    onStatsCard1Click: widget.onTotalViolationsClick,
                    onStatsCard2Click: widget.onPendingViolationsClick,
                    onStatsCard3Click: widget.onTotalVehiclesClick,
                    onStatsCard4Click: widget.onTotalEntriesExitsClick,
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
                        prev.fleetLogsData != curr.fleetLogsData ||
                        prev.violationTrendData != curr.violationTrendData,
                //Flutter, rebuild this widget only if the city breakdown list changed.
                // step 18
                builder: (context, state) {
                  return GlobalChartsSection(
                    onTimeRangeChanged1: (value) {
                      _onFleetLogsTimeRangeChanged(value);
                    },
                    onTimeRangeChanged2: (value) {
                      _onViolationTrendTimeRangeChanged(value);
                    },
                    hoverDy: widget.hoverDy,
                    vehicleLogsTimeRange: state.vehicleLogsTimeRange,
                    violationTrendTimeRange: state.violationTrendTimeRange,
                    lineChartTitle1: DynamicTitleFormatter()
                        .getDynamicVehicleLogsTrendTitle(
                          'Vehicle logs trend for ',
                          state.vehicleLogsTimeRange,
                        ),
                    yearLevelBreakdown:
                        state.yearLevelBreakdown, // realtime step 19
                    vehicleDistribution: state.vehicleDistribution,
                    studentWithMostViolations:
                        state.topStudentsWithMostViolations,
                    cityBreakdown: state.cityBreakdown,

                    vehicleLogsDistributionPerCollege:
                        state.vehicleLogsDistributionPerCollege,
                    violationDistributionPerCollege:
                        state.violationDistributionPerCollege,

                    violationTypeDistribution: state.violationTypeDistribution,
                    fleetLogsData:
                        state.fleetLogsData, // realtime fleet logs trend
                    lineChartTitle2: DynamicTitleFormatter()
                        .getDynamicViolationTrendTitle(
                          'Violation trend for ',
                          state.violationTrendTimeRange,
                        ),
                    violationTrendData: state.violationTrendData,
                    // Chart tap handlers
                    onVehicleDistributionTap: widget.onVehicleDistributionTap,
                    onYearLevelBreakdownTap: widget.onYearLevelBreakdownTap,
                    onTopViolatorsTap: widget.onTopViolatorsTap,
                    onTopCitiesTap: widget.onTopCitiesTap,
                    onVehicleLogsDistributionTap:
                        widget.onVehicleLogsDistributionTap,
                    onViolationDistributionTap:
                        widget.onViolationDistributionTap,
                    onTopViolationsTap: widget.onTopViolationsTap,
                    onFleetLogsTap: widget.onFleetLogsTap,
                    onViolationTrendTap: widget.onViolationTrendTap,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
