import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/stats_card.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/bloc/vehicle_monitoring_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DashboardOverview extends StatelessWidget {
  final double angle;
  final bool isWhiteTheme;
  const DashboardOverview({
    super.key,
    this.angle = 0.03,
    this.isWhiteTheme = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleMonitoringCubit, VehicleMonitoringState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: StatsCard(
                isWhiteTheme: isWhiteTheme,
                angle: angle,
                color: AppColors.white,
                icon: PhosphorIconsBold.signIn,
                label: "Entered Vehicles",
                value: state.totalEntered,
                gradient: AppColors.greenWhite,
                iconColor: AppColors.chartGreenv2,
              ),
            ),
            const Spacing.horizontal(size: AppSpacing.medium),
            Expanded(
              child: StatsCard(
                isWhiteTheme: isWhiteTheme,
                angle: angle,
                color: AppColors.white,
                icon: PhosphorIconsBold.signOut,
                label: "Exited Vehicles",
                value: state.totalExited,
                gradient: AppColors.yellowOrange,
                iconColor: AppColors.chartOrange,
              ),
            ),
            const Spacing.horizontal(size: AppSpacing.medium),
            Expanded(
              child: StatsCard(
                isWhiteTheme: isWhiteTheme,
                angle: angle,
                color: AppColors.white,
                icon: PhosphorIconsBold.warning,
                label: "Total Violations",
                value: state.totalViolations,
                gradient: AppColors.purpleBlue,
                iconColor: AppColors.primary,
              ),
            ),
            const Spacing.horizontal(size: AppSpacing.medium),
            Expanded(
              child: StatsCard(
                isWhiteTheme: isWhiteTheme,
                angle: angle,
                color: AppColors.white,
                icon: PhosphorIconsBold.motorcycle,
                label: "Total Vehicles",
                value: state.totalVehicles,
                gradient: AppColors.pinkWhite,
                iconColor: AppColors.donutPink,
              ),
            ),
          ],
        );
      },
    );
  }
}
