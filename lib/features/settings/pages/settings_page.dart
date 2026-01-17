import 'package:cvms_desktop/features/settings/widgets/settings_section.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/layout/custom_divider.dart';
import '../../../core/widgets/layout/spacing.dart';
import '../widgets/settings_page_header.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.07,
            vertical: AppSpacing.medium,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsPageHeader(title: 'Settings'),
              Spacing.vertical(size: AppSpacing.medium),
              CustomDivider(
                direction: Axis.horizontal,
                thickness: 1,
                color: AppColors.dividerColor.withValues(alpha: 0.4),
              ),
              Spacing.vertical(size: AppSpacing.medium),
              SettingsSection(
                title: 'General',
                children: [
                  SettingsDetailRow(label: 'Sample', value: 'Sample'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Sample', value: 'Sample'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Sample', value: 'Sample'),
                ],
              ),
              Spacing.vertical(size: AppSpacing.medium),
              SettingsSection(
                title: 'Theme',
                children: [
                  SettingsDetailRow(label: 'Sample', value: 'Sample'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Sample', value: 'Sample'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Sample', value: 'Sample'),
                ],
              ),
              Spacing.vertical(size: AppSpacing.medium),
              SettingsSection(
                title: 'Account',
                children: [
                  SettingsDetailRow(label: 'Sample', value: 'Sample'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Sample', value: 'Sample'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Sample', value: 'Sample'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
