import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/widgets/components/stats/stats_card_section.dart';
import 'package:cvms_desktop/features/dashboard/widgets/components/info/vehicle_info_card.dart';
import 'package:flutter/material.dart';

class IndividualStatsSection extends StatelessWidget {
  final VoidCallback? onVehicleInfoFullView;
  final int daysUntilExpiration;
  final int totalPendingViolations;
  final int totalViolations;
  final int totalVehicleLogs;
  //info
  final String plateNumber;
  final String ownerName;
  final String vehicleType;
  final String department;
  final String status;
  final String vehicleModel;
  final DateTime createdAt;
  final DateTime expiryDate;

  // MVP Progress fields
  final double mvpProgress;
  final DateTime mvpRegisteredDate;
  final DateTime mvpExpiryDate;
  final String mvpStatusText;

  const IndividualStatsSection({
    super.key,
    this.onVehicleInfoFullView,
    required this.daysUntilExpiration,
    required this.totalPendingViolations,
    required this.totalViolations,
    required this.totalVehicleLogs,
    //info
    required this.plateNumber,
    required this.ownerName,
    required this.vehicleType,
    required this.department,
    required this.status,
    required this.vehicleModel,
    required this.createdAt,
    required this.expiryDate,
    required this.mvpProgress,
    required this.mvpRegisteredDate,
    required this.mvpExpiryDate,
    required this.mvpStatusText,
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
              plateNumber: plateNumber,
              ownerName: ownerName,
              vehicleType: vehicleType,
              department: department,
              status: status,
              vehicleModel: vehicleModel,
              createdAt: createdAt,
              expiryDate: expiryDate,
              mvpProgress: mvpProgress,
              mvpRegisteredDate: mvpRegisteredDate,
              mvpExpiryDate: mvpExpiryDate,
              mvpStatusText: mvpStatusText,
            ),
          ),
        ],
      ),
    );
  }
}
