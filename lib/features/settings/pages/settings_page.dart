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
            horizontal: screenWidth * 0.09,
            vertical: AppSpacing.medium,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsPageHeader(title: 'Settings'),

              Spacing.vertical(size: AppSpacing.large),
              SettingsSection(
                icon: 'person',
                title: 'Account & Security',
                children: [
                  SettingsDetailRow(label: 'Display name', value: 'John Doe'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(
                    label: 'Email',
                    value: 'john.doe@example.com',
                  ),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(
                    label: 'Change password',
                    value: 'Last changed 30 days ago',
                  ),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(
                    label: 'Multi-factor authentication',
                    value: 'Enabled',
                  ),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(
                    label: 'Active sessions',
                    value: '3 devices',
                  ),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'API Keys', value: '2 keys'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'SSO Provider', value: 'None'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(
                    label: 'Session timeout',
                    value: '30 minutes',
                  ),
                ],
              ),
              Spacing.vertical(size: AppSpacing.medium),
              SettingsSection(
                icon: 'notification',
                title: 'Notifications & Alerts',
                children: [
                  SettingsDetailRow(label: 'Notifications', value: 'Enabled'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'In-app alerts', value: 'Enabled'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(
                    label: 'Email notifications',
                    value: 'Enabled',
                  ),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'SMS alerts', value: 'Disabled'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Alert threshold', value: 'Medium'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(
                    label: 'Quiet hours',
                    value: '22:00 - 08:00',
                  ),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Daily digest', value: '07:00 AM'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(
                    label: 'Escalation rules',
                    value: '3 rules configured',
                  ),
                ],
              ),
              Spacing.vertical(size: AppSpacing.medium),
              SettingsSection(
                icon: 'customization',
                title: 'Appearance & Accessibility',
                children: [
                  SettingsDetailRow(label: 'Theme', value: 'System'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Accent color', value: '#1976D2'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Density', value: 'Comfortable'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Font size', value: 'Normal'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'High contrast', value: 'Disabled'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Reduced motion', value: 'Disabled'),
                ],
              ),
              Spacing.vertical(size: AppSpacing.medium),
              SettingsSection(
                icon: 'widgets',
                title: 'Dashboard & Widgets',
                children: [
                  SettingsDetailRow(label: 'Default view', value: 'Overview'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(
                    label: 'Default date range',
                    value: 'Last 7 days',
                  ),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Auto-refresh', value: '30 seconds'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(
                    label: 'Show/hide widgets',
                    value: '5 widgets visible',
                  ),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Aggregation', value: 'Auto'),
                ],
              ),
              Spacing.vertical(size: AppSpacing.medium),
              SettingsSection(
                icon: 'reports',
                title: 'Reporting & Exports',
                children: [
                  SettingsDetailRow(label: 'Export format', value: 'CSV'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Include PII', value: 'Disabled'),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(
                    label: 'Auto-export',
                    value: 'Daily at 2:00 AM',
                  ),
                  CustomDivider(
                    direction: Axis.horizontal,
                    thickness: 1,
                    color: AppColors.dividerColor.withValues(alpha: 0.4),
                  ),
                  SettingsDetailRow(label: 'Storage location', value: 'Local'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
