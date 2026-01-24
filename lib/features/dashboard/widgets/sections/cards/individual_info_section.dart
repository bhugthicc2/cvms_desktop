import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/dashboard/widgets/components/cards/vehicle_info_card.dart';
import 'package:flutter/material.dart';

class IndividualInfoSection extends StatelessWidget {
  final VoidCallback? onVehicleInfoFullView;
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
  final double hoverDy;

  const IndividualInfoSection({
    super.key,
    this.onVehicleInfoFullView,
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
    this.hoverDy = -0.01,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        AppSpacing.medium,
        0,
        AppSpacing.medium,
      ),

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
    );
  }
}
