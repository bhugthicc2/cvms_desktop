import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/components/stats/stats_card_section.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/components/info/vehicle_info_card.dart';
import 'package:cvms_desktop/features/dashboard2/models/individual_vehicle_report.dart';
import 'package:flutter/material.dart';

class IndividualStatsSection extends StatelessWidget {
  final VoidCallback? onVehicleInfoFullView;
  final IndividualVehicleReport report;
  final int daysUntilExpiration;
  final int totalPendingViolations;
  final int totalViolations;
  final int totalVehicleLogs;

  const IndividualStatsSection({
    super.key,
    required this.report,
    this.onVehicleInfoFullView,
    required this.daysUntilExpiration,
    required this.totalPendingViolations,
    required this.totalViolations,
    required this.totalVehicleLogs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        AppSpacing.medium,
        AppSpacing.medium,
        0,
      ),
      child: Row(
        children: [
          // Stats Cards
          Expanded(
            child: StatsCardSection(
              isGlobal: false,
              statsCard1Label: 'Days Until Expiration',
              statsCard1Icon: Icons.calendar_today,
              statsCard1Value: daysUntilExpiration,
              statsCard2Label: 'Active Violations',
              statsCard2Icon: Icons.warning,
              statsCard2Value: totalPendingViolations,
              statsCard3Label: 'Total Violations',
              statsCard3Icon: Icons.error,
              statsCard3Value: totalViolations,
              statsCard4Label: 'Total Entries/Exits',
              statsCard4Value: totalVehicleLogs,
            ),
          ),

          Spacing.horizontal(size: AppSpacing.medium),

          // Vehicle Info Card
          Expanded(
            child: VehicleInfoCard(
              onViewTap: onVehicleInfoFullView ?? () {},
              report: report,
            ),
          ),
        ],
      ),
    );
  }
}
