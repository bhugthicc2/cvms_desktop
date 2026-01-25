import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/custom_divider.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TopBarMetrics {
  final int totalVehicles;
  final int onsiteVehicles;
  final int offsiteVehicles;
  final int twoWheeled;
  final int fourWheeled;

  const TopBarMetrics({
    required this.totalVehicles,
    required this.onsiteVehicles,
    required this.offsiteVehicles,
    required this.twoWheeled,
    required this.fourWheeled,
  });
}

class TopBar extends StatelessWidget {
  final TopBarMetrics metrics;

  const TopBar({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Total Vehicles
          _buildMetricItem(
            icon: PhosphorIconsBold.car,
            label: 'Total Vehicles: ',
            value: metrics.totalVehicles.toString(),
            valueColor: AppColors.primary,
          ),

          Spacing.horizontal(),
          CustomDivider(
            direction: Axis.vertical,
            thickness: 2,
            color: AppColors.grey.withValues(alpha: 0.1),
          ),
          Spacing.horizontal(),

          // On Campus Vehicles
          _buildMetricItem(
            icon: PhosphorIconsBold.mapPin,
            label: 'On Campus: ',
            value: metrics.onsiteVehicles.toString(),
            valueColor: AppColors.primary,
          ),

          Spacing.horizontal(),
          CustomDivider(
            direction: Axis.vertical,
            thickness: 2,
            color: AppColors.grey.withValues(alpha: 0.1),
          ),
          Spacing.horizontal(),

          // Off Campus Vehicles
          _buildMetricItem(
            icon: PhosphorIconsBold.house,
            label: 'Off Campus: ',
            value: metrics.offsiteVehicles.toString(),
            valueColor: AppColors.primary,
          ),

          Spacing.horizontal(),
          CustomDivider(
            direction: Axis.vertical,
            thickness: 2,
            color: AppColors.grey.withValues(alpha: 0.1),
          ),
          Spacing.horizontal(),

          // Vehicle Type Distribution
          _buildMetricItem(
            icon: PhosphorIconsBold.house,
            label: '2 Wheeled: ',
            value: metrics.twoWheeled.toString(),
            valueColor: AppColors.primary,
          ),
          Spacing.horizontal(),
          CustomDivider(
            direction: Axis.vertical,
            thickness: 2,
            color: AppColors.grey.withValues(alpha: 0.1),
          ),
          Spacing.horizontal(),

          // Vehicle Type Distribution
          _buildMetricItem(
            icon: PhosphorIconsBold.house,
            label: '4 Wheeled: ',
            value: metrics.fourWheeled.toString(),
            valueColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor = AppColors.black,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.grey),
        Spacing.horizontal(size: AppSpacing.xSmall),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.grey)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.black,
            fontSize: AppFontSizes.medium,
            shadows: [
              Shadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
