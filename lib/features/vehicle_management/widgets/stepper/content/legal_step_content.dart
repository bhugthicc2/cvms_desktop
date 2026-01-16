import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field2.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/texts/content_title.dart';
import 'package:flutter/material.dart';

class LegalStepContent extends StatefulWidget {
  final double horizontalPadding;
  const LegalStepContent({super.key, required this.horizontalPadding});

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
      padding: EdgeInsets.symmetric(
        horizontal: widget.horizontalPadding,
        vertical: AppSpacing.large,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentTitle(
            title: 'Legal Details',
            subtitle: 'Please provide the legal vehcicle details',
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
