import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown2.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field2.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class AddressStepContent extends StatefulWidget {
  const AddressStepContent({super.key});

  @override
  State<AddressStepContent> createState() => _AddressStepContentState();
}

class _AddressStepContentState extends State<AddressStepContent> {
  late final TextEditingController _purokController;
  @override
  void initState() {
    super.initState();
    _purokController = TextEditingController();
  }

  @override
  void dispose() {
    _purokController.dispose();
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
            'Address',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          Text(
            'Please provide the address details',
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
                child: CustDropDown(
                  hintText: "Region",
                  items: const [
                    CustDropdownMenuItem(
                      value: 'Region I',
                      child: Text(
                        "Region I",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'Region II',
                      child: Text(
                        "Region II",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'Region III',
                      child: Text(
                        "Region III",
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
              const Spacing.horizontal(size: AppSpacing.large),
              Expanded(
                child: CustDropDown(
                  hintText: "Province",
                  items: const [
                    CustDropdownMenuItem(
                      value: 'Zamboanga Peninsula',
                      child: Text(
                        "Zamboanga Peninsula",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'Davao Region',
                      child: Text(
                        "Davao Region",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'Davao Region',
                      child: Text(
                        "Davao Region",
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
          // Row 2: Contact & School ID
          Row(
            children: [
              Expanded(
                child: CustDropDown(
                  hintText: "Municipality",
                  items: const [
                    CustDropdownMenuItem(
                      value: 'Katipunan',
                      child: Text(
                        "Katipunan",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'Dipolog City',
                      child: Text(
                        "Dipolog City",
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
              const Spacing.horizontal(size: AppSpacing.large),
              Expanded(
                child: CustDropDown(
                  hintText: "Barangay",
                  items: const [
                    CustDropdownMenuItem(
                      value: 'Dos',
                      child: Text(
                        "Dos",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'San Vicente',
                      child: Text(
                        "San Vicente",
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
          CustomTextField2(
            label: 'Purok',
            controller: _purokController,
            borderColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
