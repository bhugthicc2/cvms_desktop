import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TopBarMetrics {
  final int activeSanctions;
  final int activeSuspensions;
  final int revokedMVPS;
  final int expiringSoon;

  const TopBarMetrics({
    required this.activeSanctions,
    required this.activeSuspensions,
    required this.revokedMVPS,
    required this.expiringSoon,
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
          // Active Sancions
          _buildMetricItem(
            gradient: AppColors.pinkWhite,
            icon: PhosphorIconsBold.gavel,
            label: 'Active Sanctions',
            value: metrics.activeSanctions,
            iconColor: AppColors.donutPurple,
          ),

          Spacing.horizontal(),

          // Active Suspensions
          _buildMetricItem(
            gradient: AppColors.greenWhite,
            icon: PhosphorIconsBold.flagBanner,
            label: 'Active Suspensions',
            value: metrics.activeSuspensions,
            valueColor: AppColors.primary,
          ),

          Spacing.horizontal(),

          // Revoked MVPS
          _buildMetricItem(
            gradient: AppColors.yellowWhite,
            icon: PhosphorIconsBold.sealWarning,
            iconColor: AppColors.chartOrange,
            label: 'Revoked MVPS',
            value: metrics.revokedMVPS,
            valueColor: AppColors.primary,
          ),

          Spacing.horizontal(),

          // Expiring Soon
          _buildMetricItem(
            gradient: AppColors.lightBlue,
            icon: PhosphorIconsBold.archive,
            label: 'Expiring soon',
            value: metrics.expiringSoon,
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
