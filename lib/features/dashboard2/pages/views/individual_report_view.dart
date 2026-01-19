import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/charts/individual_charts_section.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/stats/individual_stats_section.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/tables/recent_logs/recent_logs_table_section.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/sections/tables/violation_history/violation_history_table_section.dart';
import 'package:cvms_desktop/features/dashboard2/models/individual_vehicle_report.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class IndividualReportView extends StatelessWidget {
  final IndividualVehicleReport vehicle;

  const IndividualReportView({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //stats and info
          SizedBox(
            height: 240,
            child: IndividualStatsSection(
              report: vehicle, //todo
              onVehicleInfoFullView: () {
                //todo
              },
            ),
          ),

          IndividualChartsSection(violationDistribution: [], vehicleLogs: []),

          ViolationHistoryTableSection(
            allowSorting: false,
            istableHeaderDark: false,
            violationHistoryEntries: [],
            sectionTitle: 'Violation History',
            onClick: () {
              //todo
            },
          ),
          RecentLogsTableSection(
            allowSorting: false,
            istableHeaderDark: false,
            recentLogsEntries: [],
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
