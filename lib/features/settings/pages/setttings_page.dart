//TODO IMPLEMENT PROPERLY SOON
//ADD A SETTING FOR SETTING MVP EXPIRATION
import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Settings state variables will be added in future implementation

  @override
  void initState() {
    super.initState();
    // Settings initialization will be added in future implementation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsHeader(),
            Spacing.vertical(size: AppSpacing.medium),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 2, child: _buildAppearanceSettings()),
                  Spacing.horizontal(size: AppSpacing.medium),
                  Expanded(flex: 2, child: _buildNotificationSettings()),
                  Spacing.horizontal(size: AppSpacing.medium),
                  Expanded(flex: 2, child: _buildDashboardSettings()),
                ],
              ),
            ),
            Spacing.vertical(size: AppSpacing.medium),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 2, child: _buildSecuritySettings()),
                  Spacing.horizontal(size: AppSpacing.medium),
                  Expanded(flex: 2, child: _buildDataSettings()),
                  Spacing.horizontal(size: AppSpacing.medium),
                  Expanded(flex: 2, child: _buildSystemSettings()),
                ],
              ),
            ),
            Spacing.vertical(size: AppSpacing.medium),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsHeader() {
    return Container(
      height: 100, // Fixed height to maintain layout
      width: double.infinity,
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
      child: const SizedBox.shrink(), // Empty container
    );
  }

  Widget _buildAppearanceSettings() {
    return _buildSection(
      title: 'Appearance',
      icon: null,
      children: [
        // Content will be added in future implementation
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return _buildSection(
      title: 'Notifications',
      icon: null,
      children: [
        // Content will be added in future implementation
      ],
    );
  }

  Widget _buildDashboardSettings() {
    return _buildSection(
      title: 'Dashboard',
      icon: null,
      children: [
        // Content will be added in future implementation
      ],
    );
  }

  Widget _buildSecuritySettings() {
    return _buildSection(
      title: 'Security',
      icon: null,
      children: [
        // Content will be added in future implementation
      ],
    );
  }

  Widget _buildDataSettings() {
    return _buildSection(
      title: 'Data Management',
      icon: null,
      children: [
        // Content will be added in future implementation
      ],
    );
  }

  Widget _buildSystemSettings() {
    return _buildSection(
      title: 'System',
      icon: null,
      children: [
        // Content will be added in future implementation
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      height: 180, // Fixed height to maintain layout
      width: double.infinity,
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
      child: const SizedBox.shrink(), // Empty container
    );
  }

  Widget _buildSection({
    required String title,
    required IconData? icon,
    required List<Widget> children,
  }) {
    return Container(
      height: 200, // Fixed height to maintain layout
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
      child: const SizedBox.shrink(), // Empty container
    );
  }

  // Action methods will be added in future implementation
}
