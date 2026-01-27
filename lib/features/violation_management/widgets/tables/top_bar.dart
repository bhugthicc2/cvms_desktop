import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TopBarMetrics {
  final int pendingViolations;
  final int confirmedViolations;
  final int dismissedViolations;
  final int sanctionedVehicles;

  const TopBarMetrics({
    required this.pendingViolations,
    required this.confirmedViolations,
    required this.dismissedViolations,
    required this.sanctionedVehicles,
  });
}

class TopBar extends StatelessWidget {
  final TopBarMetrics metrics;

  const TopBar({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Total Vehicles
          _buildMetricItem(
            gradient: AppColors.purpleBlue,
            icon: PhosphorIconsBold.car,
            label: 'Pending Violations',
            value: metrics.pendingViolations,
            valueColor: AppColors.primary,
          ),

          Spacing.horizontal(),

          // Off Campus Vehicles
          _buildMetricItem(
            gradient: AppColors.greenWhite,
            icon: PhosphorIconsBold.lightning,
            label: 'Confirmed Violations',
            value: metrics.confirmedViolations,
            valueColor: AppColors.primary,
          ),

          Spacing.horizontal(),

          // On Campus Vehicles
          _buildMetricItem(
            gradient: AppColors.yellowWhite,
            icon: PhosphorIconsBold.mapPin,
            iconColor: AppColors.chartOrange,
            label: 'Dismissed Violations',
            value: metrics.dismissedViolations,
            valueColor: AppColors.primary,
          ),

          Spacing.horizontal(),

          // Vehicle Type Distribution
          _buildMetricItem(
            gradient: AppColors.lightBlue,
            icon: PhosphorIconsBold.motorcycle,
            label: 'Sanctioned Vehicles',
            value: metrics.sanctionedVehicles,
            valueColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required int value,
    required Gradient gradient,
    Color? iconColor = AppColors.donutBlue,
    Color? valueColor = AppColors.black,
  }) {
    return Expanded(
      child: StatsCard(
        icon: icon,
        label: label,
        gradient: gradient,
        value: value,
        addSideBorder: false,
        color: AppColors.donutPurple,
        iconColor: iconColor,
        cardBorderRadii: 4,
        iconContainerRadii: 4,
      ),
    );
  }
}
