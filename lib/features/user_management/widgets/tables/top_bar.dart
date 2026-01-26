import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TopBarMetrics {
  final int totalUsers;
  final int activeUsers;
  final int inActiveUsers;
  final int usersLoggedInRecently;

  const TopBarMetrics({
    required this.totalUsers,
    required this.activeUsers,
    required this.inActiveUsers,
    required this.usersLoggedInRecently,
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
          _buildMetricItem(
            gradient: AppColors.purpleBlue,
            icon: PhosphorIconsBold.car,
            label: 'Total Users',
            value: metrics.totalUsers,
            valueColor: AppColors.primary,
          ),

          Spacing.horizontal(),

          _buildMetricItem(
            gradient: AppColors.greenWhite,
            icon: PhosphorIconsBold.lightning,
            label: 'Active Users',
            value: metrics.activeUsers,
            valueColor: AppColors.primary,
          ),

          Spacing.horizontal(),

          _buildMetricItem(
            gradient: AppColors.yellowWhite,
            icon: PhosphorIconsBold.mapPin,
            iconColor: AppColors.chartOrange,
            label: 'Inactive Users',
            value: metrics.inActiveUsers,
            valueColor: AppColors.primary,
          ),

          Spacing.horizontal(),

          _buildMetricItem(
            gradient: AppColors.lightBlue,
            icon: PhosphorIconsBold.motorcycle,
            label: 'Users Logged in recently',
            value: metrics.usersLoggedInRecently,
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
