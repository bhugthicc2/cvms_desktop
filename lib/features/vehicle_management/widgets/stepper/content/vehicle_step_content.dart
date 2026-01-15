import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown2.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field2.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/options/option_widget.dart';
import 'package:flutter/material.dart';

class VehicleStepContent extends StatefulWidget {
  const VehicleStepContent({super.key});

  @override
  State<VehicleStepContent> createState() => _VehicleStepContentState();
}

class _VehicleStepContentState extends State<VehicleStepContent> {
  late final TextEditingController _plateNumberController;
  @override
  void initState() {
    super.initState();
    _plateNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _plateNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleTypeOptions = [
      OptionItem(label: 'Two-wheeled', icon: Icons.male, value: 'two-wheeled'),
      OptionItem(
        label: 'Four-wheeled',
        icon: Icons.female,
        value: 'four-wheeled',
      ),
      OptionItem(label: 'Other', icon: Icons.more_horiz, value: 'other'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxxLarge + 10,
        vertical: AppSpacing.large,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vehicle Information',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          Text(
            'Please provide the vehicle specification details',
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
                  label: 'Plate number',
                  controller: _plateNumberController,
                  borderColor: AppColors.primary,
                ),
              ),
              const Spacing.horizontal(size: AppSpacing.large),
              Expanded(
                child: CustomTextField2(
                  label: 'Vehicle Model',
                  controller: _plateNumberController,
                  borderColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const Spacing.vertical(size: AppSpacing.medium),
          // Row 2: Contact & School ID
          Row(
            children: [
              Expanded(
                child: CustomTextField2(
                  label: 'Vehicle Color',
                  controller: _plateNumberController,
                  borderColor: AppColors.primary,
                ),
              ),
              const Spacing.horizontal(size: AppSpacing.large),
              Expanded(
                child: CustDropDown(
                  hintText: "Vehicle type",
                  items: const [
                    CustDropdownMenuItem(
                      value: 'Two-wheeled',
                      child: Text(
                        "Two-wheeled",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'Four-wheeled',
                      child: Text(
                        "Four-wheeled",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'Other',
                      child: Text(
                        "Other",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                  ],

                  borderRadius: 5,
                  onChanged: (val) {
                    debugPrint(val.toString()); //to be removed
                  },
                ),
              ),
            ],
          ),
          const Spacing.vertical(size: AppSpacing.medium),
        ],
      ),
    );
  }
}
