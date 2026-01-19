import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/charts/individual_charts_section.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/stats/individual_stats_section.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/tables/recent_logs/recent_logs_table_section.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/tables/violation_history/violation_history_table_section.dart';
import 'package:cvms_desktop/features/dashboard2/models/individual_vehicle_report.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class IndividualReportView extends StatelessWidget {
  final IndividualVehicleReport report;

  const IndividualReportView({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //stats and info
          SizedBox(
            height: 240,
            child: IndividualStatsSection(
              report: report, //already done
              onVehicleInfoFullView: () {
                //todo
              },
              //stat card metrics
              daysUntilExpiration:
                  0, //todo display days until expiration of the vehicle
              //calculated using calculateRemainingDays(expiryDate - currentDate)
              totalPendingViolations:
                  0, //todo display total pending violations  of the vehicle
              //get the total pending violations of the vehicle (status = "pending")
              totalViolations:
                  0, //todo display total violations  of the vehicle
              //get the total violations of the vehicle
              totalVehicleLogs:
                  0, //todo display total vehicle logs  of the vehicle
              //get the total vehicle_logs of the vehicle
            ),
          ),

          IndividualChartsSection(
            violationDistribution: [
              //todo bar chart that shows violation by type distribution of a specific vehicle
            ],
            vehicleLogs: [
              //todo line chart that shows vehicle logs of a specific vehicle
            ],
          ),

          ViolationHistoryTableSection(
            allowSorting: false,
            istableHeaderDark: false,
            violationHistoryEntries: [
              //todo 10 most recent violation history table entries of a specific vehicle
            ],
            sectionTitle: 'Violation History',
            onClick: () {
              //todo
            },
          ),
          RecentLogsTableSection(
            allowSorting: false,
            istableHeaderDark: false,
            recentLogsEntries: [
              //todo 10 most recent recent logs table entries of a specific vehicle
            ],
            sectionTitle: 'Recent Logs',
            onClick: () {
              //todo
            },
          ),
          Spacing.vertical(size: AppSpacing.medium),
        ],
      ),
    );
  }
}
