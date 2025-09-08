import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/profile/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                PhosphorIconsRegular.chartLine,
                color: AppColors.primary,
                size: 24,
              ),
              Spacing.horizontal(size: AppSpacing.small),
              const Text(
                'Activity & Statistics',
                style: TextStyle(
                  fontSize: AppFontSizes.xLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          Spacing.vertical(size: AppSpacing.medium),
          Row(
            children: const [
              Expanded(
                //todo add a real data from the firebase
                child: StatCard(
                  title: 'Last Login',
                  value: 'Today, 2:30 PM',
                  icon: PhosphorIconsRegular.clock,
                  color: AppColors.primary,
                ),
              ),
              Spacing.horizontal(size: AppSpacing.medium),
              Expanded(
                //todo add a real data from the firebase
                child: StatCard(
                  title: 'Account Created',
                  value: 'Jan 15, 2024',
                  icon: PhosphorIconsRegular.calendar,
                  color: AppColors.success,
                ),
              ),
              Spacing.horizontal(size: AppSpacing.medium),
              Expanded(
                //todo add a real data from the firebase
                child: StatCard(
                  title: 'Total Logins',
                  value: '1,247',
                  icon: PhosphorIconsRegular.signIn,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
