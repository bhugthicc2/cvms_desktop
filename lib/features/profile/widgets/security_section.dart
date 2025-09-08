import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/profile/widgets/security_action.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SecuritySection extends StatelessWidget {
  final VoidCallback onChangePassword;

  const SecuritySection({super.key, required this.onChangePassword});

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
              Icon(
                PhosphorIconsRegular.lockKey,
                color: AppColors.primary,
                size: 24,
              ),
              Spacing.horizontal(size: AppSpacing.small),
              const Text(
                'Security',
                style: TextStyle(
                  fontSize: AppFontSizes.xLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          Spacing.vertical(size: AppSpacing.medium),
          SecurityAction(
            title: 'Change Password',
            subtitle: 'Update your account password',
            icon: PhosphorIconsRegular.lock,
            onTap: onChangePassword,
          ),
          Spacing.vertical(size: AppSpacing.medium),
          SecurityAction(
            title: 'Two-Factor Authentication',
            subtitle: 'Add an extra layer of security',
            icon: PhosphorIconsRegular.deviceMobile,
            onTap: () {},
            trailing: Switch(
              value: false,
              onChanged: (value) {},
              activeColor: AppColors.primary,
            ),
          ),
          Spacing.vertical(size: AppSpacing.medium),
          SecurityAction(
            title: 'Active Sessions',
            subtitle: 'Manage your active sessions',
            icon: PhosphorIconsRegular.devices,
            onTap: () {},
          ),
          Spacing.vertical(size: AppSpacing.medium),
          SecurityAction(
            title: 'Login Activity',
            subtitle: 'View your recent login history',
            icon: PhosphorIconsRegular.clock,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
