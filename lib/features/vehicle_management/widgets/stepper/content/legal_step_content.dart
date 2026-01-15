import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field2.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class LegalStepContent extends StatefulWidget {
  const LegalStepContent({super.key});

  @override
  State<LegalStepContent> createState() => _LegalStepContentState();
}

class _LegalStepContentState extends State<LegalStepContent> {
  late final TextEditingController _licenseNumberController;
  late final TextEditingController _orNumberController;
  late final TextEditingController _crNumberController;
  @override
  void initState() {
    super.initState();
    _licenseNumberController = TextEditingController();
    _orNumberController = TextEditingController();
    _crNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _licenseNumberController.dispose();
    _orNumberController.dispose();
    _crNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxxLarge + 10,
        vertical: AppSpacing.large,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legal Details',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          Text(
            'Please provide the legal vehcicle details',
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: AppColors.grey,
            ),
          ),
          const Spacing.vertical(size: AppSpacing.large),
          // Row 1: Owner Name & Gender
          Row(
            children: [
              Expanded(
                child: CustomTextField2(
                  label: 'License number',
                  controller: _licenseNumberController,
                  borderColor: AppColors.primary,
                ),
              ),
              const Spacing.horizontal(size: AppSpacing.large),
              Expanded(
                child: CustomTextField2(
                  label: 'OR Number',
                  controller: _orNumberController,
                  borderColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const Spacing.vertical(size: AppSpacing.medium),
          // Row 2: Contact & School ID
          CustomTextField2(
            label: 'CR Number',
            controller: _crNumberController,
            borderColor: AppColors.primary,
          ),

          const Spacing.vertical(size: AppSpacing.medium),
        ],
      ),
    );
  }
}
