import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/profile/widgets/info_field.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class InfoSection extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController departmentController;
  final bool isEditing;

  const InfoSection({
    super.key,
    required this.fullNameController,
    required this.phoneController,
    required this.departmentController,
    required this.isEditing,
  });

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
                PhosphorIconsRegular.user,
                color: AppColors.primary,
                size: 24,
              ),
              Spacing.horizontal(size: AppSpacing.small),
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: AppFontSizes.xLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          Spacing.vertical(size: AppSpacing.medium),
          InfoField(
            label: 'Full Name',
            controller: fullNameController,
            icon: PhosphorIconsRegular.user,
            enabled: isEditing,
          ),
          Spacing.vertical(size: AppSpacing.medium),
          InfoField(
            label: 'Phone Number',
            controller: phoneController,
            icon: PhosphorIconsRegular.phone,
            enabled: isEditing,
          ),
          Spacing.vertical(size: AppSpacing.medium),
          InfoField(
            label: 'Department',
            controller: departmentController,
            icon: PhosphorIconsRegular.buildings,
            enabled: isEditing,
          ),
          Spacing.vertical(size: AppSpacing.medium),
          const InfoField(
            label: 'Role',
            value: 'Administrator',
            icon: PhosphorIconsRegular.shield,
            enabled: false,
          ),
        ],
      ),
    );
  }
}
