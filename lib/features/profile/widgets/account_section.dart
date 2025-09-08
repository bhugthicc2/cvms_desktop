import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/profile/widgets/info_field.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AccountSection extends StatelessWidget {
  final TextEditingController emailController;

  const AccountSection({super.key, required this.emailController});

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
          const _Header(),
          Spacing.vertical(size: AppSpacing.medium),
          _Fields(emailController: emailController),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(PhosphorIconsRegular.gear, color: AppColors.primary, size: 24),
        Spacing.horizontal(size: AppSpacing.small),
        const Text(
          'Account Settings',
          style: TextStyle(
            fontSize: AppFontSizes.xLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}

class _Fields extends StatelessWidget {
  final TextEditingController emailController;

  const _Fields({required this.emailController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InfoField(
          label: 'Email Address',
          controller: emailController,
          icon: PhosphorIconsRegular.envelope,
          enabled: false,
        ),
        const Spacing.vertical(size: AppSpacing.medium),
        const InfoField(
          label: 'Username',
          value: 'admin',
          icon: PhosphorIconsRegular.userCircle,
          enabled: false,
        ),
        const Spacing.vertical(size: AppSpacing.medium),
        const InfoField(
          label: 'Language',
          value: 'English',
          icon: PhosphorIconsRegular.globe,
          enabled: false,
        ),
        const Spacing.vertical(size: AppSpacing.medium),
        const InfoField(
          label: 'Theme',
          value: 'Light Mode',
          icon: PhosphorIconsRegular.sun,
          enabled: false,
        ),
      ],
    );
  }
}
