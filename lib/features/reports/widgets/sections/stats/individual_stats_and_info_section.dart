import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import '../../../utils/mvp_progress_calculator.dart';
import 'stats_card_section.dart';
import '../vehicle_info_section.dart';

/// Individual Stats and Info Section - Displays individual vehicle statistics and information including:
/// - Days until expiration
/// - Active violations
/// - Total violations
/// - Total entries/exits
/// - Vehicle information panel with MVP progress
class IndividualStatsAndInfoSection extends StatelessWidget {
  const IndividualStatsAndInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final registeredDate = DateTime(2025, 5, 23);
    final expiryDate = DateTime(2026, 12, 2);
    final mvpProgress = MvpProgressCalculator.calculateProgress(
      registeredDate: registeredDate,
      expiryDate: expiryDate,
    );

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: const StatsCardSection(
            statsCard1Label: 'Days Until Expiration',
            statsCard1Value: 150,
            statsCard2Label: 'Active Violations',
            statsCard2Value: 22,
            statsCard3Label: 'Total Violations',
            statsCard3Value: 230,
            statsCard4Label: 'Total Entries/Exits',
            statsCard4Value: 540,
          ),
        ),
        Spacing.horizontal(size: AppSpacing.medium),
        Expanded(
          flex: 2,
          child: VehicleInfoSection(
            title: 'Vehicle Information',
            onViewTap: () {},
            vehicleModel: 'Toyota Avanza',
            plateNumber: 'WXY-9012',
            vehicleType: 'Four-wheeled',
            ownerName: 'Mila Hernandez',
            department: 'CAF-SOE',
            status: 'Offsite',
            mvpProgress: mvpProgress,
            mvpRegisteredDate: registeredDate,
            mvpExpiryDate: expiryDate,
          ),
        ),
      ],
    );
  }
}
