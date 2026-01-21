import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard/individual/individual_dashboard_cubit.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard/individual/individual_dashboard_state.dart';
import 'package:cvms_desktop/features/dashboard/utils/dynamic_title_formatter.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/charts/individual_charts_section.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/stats/individual_stats_section.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/tables/recent_logs/recent_logs_table_section.dart';
import 'package:cvms_desktop/features/dashboard/widgets/sections/tables/violation_history/violation_history_table_section.dart';
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

  const IndividualReportView({
    super.key,
    required this.vehicleInfo,
    this.currentTimeRange = '7 days',
  });

  void _onTimeRangeChanged(String selectedRange, BuildContext context) {
    // Update time range in cubit state
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
        _showCustomDatePicker(context);
        return;
      default:
        return;
    }

    // Apply selected date range to individual vehicle logs trend
    context.read<IndividualDashboardCubit>().updateDateFilter(
      start: startDate,
      end: endDate,
      grouping: TimeGrouping.day,
    );
  }

  void _showCustomDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomAlertDialog(
          title: 'Select Date Range',
          child: CustomDateFilter(
            onApply: (period) {
              if (period != null) {
                // Update current time range to reflect custom selection
                context.read<IndividualDashboardCubit>().updateDateFilter(
                  start: period.start,
                  end: period.end,
                  grouping: TimeGrouping.day,
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
                      onVehicleInfoFullView: () {
                        //todo
                      },
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
                    );
                  },
                ),
              ),

              BlocBuilder<IndividualDashboardCubit, IndividualDashboardState>(
                builder: (context, state) {
                  return IndividualChartsSection(
                    //ISSUE: doesn't update on load
                    violationDistribution: state.violationDistribution,
                    vehicleLogs: state.vehicleLogsTrend, //default to 7 days
                    lineChartTitle: DynamicTitleFormatter().getDynamicTitle(
                      'Vehicle logs for ',
                      currentTimeRange,
                    ), //todo fix the issue where the dynamic title is not working/updating
                    onTimeRangeChanged: (value) {
                      _onTimeRangeChanged(value, context);
                    },
                  );
                },
              ),

              BlocBuilder<IndividualDashboardCubit, IndividualDashboardState>(
                builder: (context, state) {
                  return ViolationHistoryTableSection(
                    allowSorting: false,
                    istableHeaderDark: false,
                    violationHistoryEntries: state.violationHistory,
                    sectionTitle: 'Violation History',
                    onClick: () {
                      //todo
                    },
                  );
                },
              ),
              BlocBuilder<IndividualDashboardCubit, IndividualDashboardState>(
                builder: (context, state) {
                  return RecentLogsTableSection(
                    allowSorting: false,
                    istableHeaderDark: false,
                    recentLogsEntries: state.recentLogs,
                    sectionTitle: 'Recent Logs',
                    onClick: () {
                      //todo
                    },
                  );
                },
              ),
              Spacing.vertical(size: AppSpacing.medium),
            ],
          ),
        );
      },
    );
  }
}
