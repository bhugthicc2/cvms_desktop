import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard/individual/individual_dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard/individual/individual_dashboard_state.dart';
import 'package:cvms_desktop/features/dashboard/utils/dynamic_title_formatter.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/charts/individual_charts_section.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/stats/individual_stats_section.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/individual_vehicle_info.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/time_grouping.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/widgets/app/custom_alert_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_date_filter.dart';

class IndividualReportView extends StatelessWidget {
  final IndividualVehicleInfo vehicleInfo;
  final String? currentTimeRange;
  final double hoverDy;
  // Stats card onclick handlers
  final VoidCallback? onDaysUntilExpirationClick;
  final VoidCallback? onActiveViolationsClick;
  final VoidCallback? onTotalViolationsClick;
  final VoidCallback? onTotalEntriesExitsClick;
  final VoidCallback? onVehicleInfoFullView;
  // Chart view tap handlers
  final VoidCallback? onViolationDistributionTap;
  final VoidCallback? onVehicleLogsTap;
  final VoidCallback? onViolationTrendTap;

  const IndividualReportView({
    super.key,
    required this.vehicleInfo,
    this.currentTimeRange = '7 days',
    this.hoverDy = -0.01,
    this.onDaysUntilExpirationClick,
    this.onActiveViolationsClick,
    this.onTotalViolationsClick,
    this.onTotalEntriesExitsClick,
    this.onVehicleInfoFullView,
    this.onViolationDistributionTap,
    this.onVehicleLogsTap,
    this.onViolationTrendTap,
  });

  void _onVehicleLogsTimeRangeChanged(
    String selectedRange,
    BuildContext context,
  ) {
    // Update time range in cubit state
    DateTime endDate = DateTime.now();
    DateTime startDate;

    switch (selectedRange) {
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
        _showVehicleLogsCustomDatePicker(context);
        return;
      default:
        return;
    }

    // Apply selected date range to individual vehicle logs trend
    context.read<IndividualDashboardCubit>().updateVehicleLogsDateFilter(
      start: startDate,
      end: endDate,
      grouping: TimeGrouping.day,
      vehicleLogsCurrentTimeRange: selectedRange,
    );
  }

  void _onViolationTrendTimeRangeChanged(
    String selectedRange,
    BuildContext context,
  ) {
    // Update time range in cubit state
    DateTime endDate = DateTime.now();
    DateTime startDate;

    switch (selectedRange) {
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
        _showViolationTrendCustomDatePicker(context);
        return;
      default:
        return;
    }

    // Apply selected date range to individual vehicle logs trend
    context.read<IndividualDashboardCubit>().updateViolationDateFilter(
      start: startDate,
      end: endDate,
      grouping: TimeGrouping.day,
      violationTrendCurrentTimeRange: selectedRange,
    );
  }

  void _showVehicleLogsCustomDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomAlertDialog(
          title: 'Select Date Range',
          child: CustomDateFilter(
            onApply: (period) {
              if (period != null) {
                // Update current time range to reflect custom selection
                context
                    .read<IndividualDashboardCubit>()
                    .updateVehicleLogsDateFilter(
                      start: period.start,
                      end: period.end,
                      grouping: TimeGrouping.day,
                      vehicleLogsCurrentTimeRange: 'Custom',
                    );
              }
              Navigator.of(dialogContext).pop();
            },
          ),
        );
      },
    );
  }

  void _showViolationTrendCustomDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomAlertDialog(
          title: 'Select Date Range',
          child: CustomDateFilter(
            onApply: (period) {
              if (period != null) {
                // Update current time range to reflect custom selection
                context
                    .read<IndividualDashboardCubit>()
                    .updateViolationDateFilter(
                      start: period.start,
                      end: period.end,
                      grouping: TimeGrouping.day,
                      violationTrendCurrentTimeRange: 'Custom',
                    );
              }
              Navigator.of(dialogContext).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndividualDashboardCubit, IndividualDashboardState>(
      builder: (context, state) {
        if (state.loading) {
          Center(child: Text('Loading please wait...'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              //stats and info
              SizedBox(
                height: 240,
                child: BlocBuilder<
                  IndividualDashboardCubit,
                  IndividualDashboardState
                >(
                  builder: (context, state) {
                    return IndividualStatsSection(
                      onVehicleInfoFullView: onVehicleInfoFullView,
                      onDaysUntilExpirationClick: onDaysUntilExpirationClick,
                      onActiveViolationsClick: onActiveViolationsClick,
                      onTotalViolationsClick: onTotalViolationsClick,
                      onTotalEntriesExitsClick: onTotalEntriesExitsClick,
                      //stat card metrics
                      daysUntilExpiration: vehicleInfo.daysUntilExpiration,
                      totalViolations: state.totalViolations,
                      totalPendingViolations: state.totalPendingViolations,
                      totalVehicleLogs: state.totalVehicleLogs,
                      //info
                      plateNumber: vehicleInfo.plateNumber,
                      ownerName: vehicleInfo.ownerName,
                      vehicleType: vehicleInfo.vehicleType,
                      department: vehicleInfo.department,
                      status: vehicleInfo.status,
                      vehicleModel: vehicleInfo.vehicleModel,
                      createdAt: vehicleInfo.createdAt!,
                      expiryDate: vehicleInfo.expiryDate!,
                      mvpProgress: vehicleInfo.mvpProgress,
                      mvpRegisteredDate: vehicleInfo.mvpRegisteredDate!,
                      mvpExpiryDate: vehicleInfo.mvpExpiryDate!,
                      mvpStatusText: vehicleInfo.mvpStatusText,
                      hoverDy: hoverDy,
                    );
                  },
                ),
              ),

              IndividualChartsSection(
                violationDistribution: state.violationDistribution,
                //vehicle logs
                vehicleLogs: state.vehicleLogsTrend, //default to 7 days
                lineChartTitle1: DynamicTitleFormatter()
                    .getDynamicVehicleLogsTrendTitle(
                      'Vehicle logs trend for ',
                      state.vehicleLogsCurrentTimeRange,
                    ),
                onTimeRangeChanged1: (value) {
                  _onVehicleLogsTimeRangeChanged(value, context);
                },
                //violation
                lineChartTitle2: DynamicTitleFormatter()
                    .getDynamicViolationTrendTitle(
                      'Violation trend for ',
                      state.violationTrendCurrentTimeRange,
                    ),
                violationTrend: state.violationTrend,
                onTimeRangeChanged2: (value) {
                  _onViolationTrendTimeRangeChanged(value, context);
                },
                hoverDy: hoverDy,
                // Chart tap handlers
                onViolationDistributionTap: onViolationDistributionTap,
                onVehicleLogsTap: onVehicleLogsTap,
                onViolationTrendTap: onViolationTrendTap,
              ),

              //TEMPORARILY DISABLE THE TABLES SINCE IT CAN BE COVERED IN THE CHART
              // ViolationHistoryTableSection(
              //   allowSorting: false,
              //   istableHeaderDark: false,
              //   violationHistoryEntries: state.violationHistory,
              //   sectionTitle: 'Violation History',
              //   onClick: () {
              //     //todo
              //   },
              //   hoverDy: hoverDy,
              // ),
              // RecentLogsTableSection(
              //   allowSorting: false,
              //   istableHeaderDark: false,
              //   recentLogsEntries: state.recentLogs,
              //   sectionTitle: 'Recent Logs',
              //   onClick: () {
              //     //todo
              //   },
              //   hoverDy: hoverDy,
              // ),
              Spacing.vertical(size: AppSpacing.medium),
            ],
          ),
        );
      },
    );
  }
}
