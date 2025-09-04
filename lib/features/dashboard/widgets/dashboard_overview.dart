import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/spacing.dart';
import 'package:cvms_desktop/features/dashboard/widgets/dashboard_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: DashboardStatsCard(
            color: AppColors.white,
            icon: PhosphorIconsBold.signIn,
            label: "Entered Vehicles",
            value: 309,
            gradient: AppColors.blueViolet,
            iconColor: AppColors.primary,
          ),
        ),
        Spacing.horizontal(size: AppSpacing.xmedium),
        Expanded(
          child: DashboardStatsCard(
            color: AppColors.white,
            icon: PhosphorIconsBold.signOut,
            label: "Exited Vehicles",
            value: 409,
            gradient: AppColors.lightBlue,
            iconColor: AppColors.primary,
          ),
        ),
        Spacing.horizontal(size: AppSpacing.xmedium),
        Expanded(
          child: DashboardStatsCard(
            color: AppColors.white,
            icon: PhosphorIconsBold.warning,
            label: "Total Violations",
            value: 234,
            gradient: AppColors.yellowOrange,
            iconColor: AppColors.orange,
          ),
        ),
        Spacing.horizontal(size: AppSpacing.xmedium),
        Expanded(
          child: DashboardStatsCard(
            color: AppColors.white,
            icon: PhosphorIconsBold.motorcycle,
            label: "Total Vehicles",
            value: 718,
            gradient: AppColors.purpleBlue,
            iconColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
