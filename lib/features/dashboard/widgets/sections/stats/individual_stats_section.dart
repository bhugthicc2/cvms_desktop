import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/dashboard/widgets/components/stats/stats_card_section.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class IndividualStatsSection extends StatelessWidget {
  final VoidCallback? onVehicleInfoFullView;
  // Stats card onclick handlers
  final VoidCallback? onDaysUntilExpirationClick;
  final VoidCallback? onActiveViolationsClick;
  final VoidCallback? onTotalViolationsClick;
  final VoidCallback? onTotalEntriesExitsClick;
  final int daysUntilExpiration;
  final int totalPendingViolations;
  final int totalViolations;
  final int totalVehicleLogs;

  final double hoverDy;

  const IndividualStatsSection({
    super.key,
    this.onVehicleInfoFullView,
    this.onDaysUntilExpirationClick,
    this.onActiveViolationsClick,
    this.onTotalViolationsClick,
    this.onTotalEntriesExitsClick,
    required this.daysUntilExpiration,
    required this.totalPendingViolations,
    required this.totalViolations,
    required this.totalVehicleLogs,
    this.hoverDy = -0.01,
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
      child: StatsCardSection(
        isGlobal: false,
        statsCard1Label: 'Days Until Expiration',
        statsCard1Icon: PhosphorIconsBold.calendarMinus,
        statsCard1Value: daysUntilExpiration,
        statsCard2Label: 'Pending Violations',
        statsCard2Icon: PhosphorIconsBold.warning,
        statsCard2Value: totalPendingViolations,
        statsCard3Label: 'Total Violations',
        statsCard3Icon: PhosphorIconsBold.warningOctagon,
        statsCard3Value: totalViolations,
        statsCard4Label: 'Total Entries/Exits',
        statsCard4Icon: PhosphorIconsBold.car,
        statsCard4Value: totalVehicleLogs,
        hoverDy: hoverDy + -0.05,
        onStatsCard1Click: onDaysUntilExpirationClick,
        onStatsCard2Click: onActiveViolationsClick,
        onStatsCard3Click: onTotalViolationsClick,
        onStatsCard4Click: onTotalEntriesExitsClick,
      ),
    );
  }
}
