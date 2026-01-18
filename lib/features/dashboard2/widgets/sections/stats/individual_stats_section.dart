import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard2/models/vehicle_info.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/components/stats/stats_card_section.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/components/info/vehicle_info_card.dart';
import 'package:cvms_desktop/features/dashboard2/models/individual_vehicle_report.dart';
import 'package:flutter/material.dart';

class IndividualStatsSection extends StatelessWidget {
  final VoidCallback? onVehicleInfoFullView;
  final IndividualVehicleReport report;

  const IndividualStatsSection({
    super.key,
    required this.report,
    this.onVehicleInfoFullView,
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
              statsCard1Value: report.daysUntilExpiration,
              statsCard2Label: 'Active Violations',
              statsCard2Icon: Icons.warning,
              statsCard2Value: report.activeViolations,
              statsCard3Label: 'Total Violations',
              statsCard3Icon: Icons.error,
              statsCard3Value: report.totalViolations,
              statsCard4Label: 'Total Entries/Exits',
              statsCard4Value: report.totalEntriesExits,
            ),
          ),

          Spacing.horizontal(size: AppSpacing.medium),

          // Vehicle Info Card
          Expanded(
            child: VehicleInfoCard(
              onViewTap: onVehicleInfoFullView ?? () {},
              vehicleInfo: VehicleInfo(
                vehicleModel: report.vehicleType,
                plateNumber: report.plateNumber,
                vehicleType: report.vehicleType,
                ownerName: report.ownerName,
                department: '',
                status: '',
                mvpProgress: 0,
                mvpRegisteredDate: report.registeredDate,
                mvpExpiryDate: report.expiryDate,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
