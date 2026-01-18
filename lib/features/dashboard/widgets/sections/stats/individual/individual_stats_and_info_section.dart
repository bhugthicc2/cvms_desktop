import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/bloc/reports/reports_cubit.dart';
import 'package:cvms_desktop/features/dashboard/bloc/reports/reports_state.dart';
import '../../../../utils/mvp_progress_calculator.dart';
import 'stats_card_section.dart';
import 'vehicle_info_section.dart';

/// Individual Stats and Info Section - Displays individual vehicle statistics and information including:
class IndividualStatsAndInfoSection extends StatelessWidget {
  const IndividualStatsAndInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        final profile = state.selectedVehicleProfile;
        final registeredDate = profile?.createdAt;
        final expiryDate = profile?.expiryDate;
        final mvpProgress = MvpProgressCalculator.calculateProgress(
          registeredDate: registeredDate,
          expiryDate: expiryDate,
        );

        return Row(
          children: [
            Expanded(
              flex: 2,
              child: StatsCardSection(
                statsCard1Label: 'Days Until Expiration',
                statsCard1Value:
                    expiryDate != null
                        ? expiryDate.difference(DateTime.now()).inDays
                        : 0,
                statsCard2Label: 'Active Violations',
                statsCard2Value: profile?.activeViolations ?? 0,
                statsCard3Label: 'Total Violations',
                statsCard3Value: profile?.totalViolations ?? 0,
                statsCard4Label: 'Total Entries/Exits',
                statsCard4Value: profile?.totalEntriesExits ?? 0,
              ),
            ),
            Spacing.horizontal(size: AppSpacing.medium),
            Expanded(
              flex: 2,
              child: VehicleInfoSection(
                title: 'Vehicle Information',
                onViewTap: () {},
                vehicleModel: profile?.model ?? '',
                plateNumber: profile?.plateNumber ?? '',
                vehicleType: profile?.vehicleType ?? '',
                ownerName: profile?.ownerName ?? '',
                department: profile?.department ?? '',
                status: profile?.status ?? '',
                mvpProgress: mvpProgress,
                mvpRegisteredDate: registeredDate,
                mvpExpiryDate: expiryDate,
              ),
            ),
          ],
        );
      },
    );
  }
}
