import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown2.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field2.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/options/option_widget.dart';
import 'package:flutter/material.dart';

class OwnerStepContent extends StatefulWidget {
  const OwnerStepContent({super.key});

  @override
  State<OwnerStepContent> createState() => _OwnerStepContentState();
}

class _OwnerStepContentState extends State<OwnerStepContent> {
  late final TextEditingController _ownerNameController;
  late final TextEditingController _genderController;
  late final TextEditingController _contactController;
  late final TextEditingController _schoolIdController;
  late final TextEditingController _departmentController;
  late final TextEditingController _yearLevelController;
  late final TextEditingController _blockController;

  @override
  void initState() {
    super.initState();
    _ownerNameController = TextEditingController();
    _genderController = TextEditingController();
    _contactController = TextEditingController();
    _schoolIdController = TextEditingController();
    _departmentController = TextEditingController();
    _yearLevelController = TextEditingController();
    _blockController = TextEditingController();
  }

  @override
  void dispose() {
    _ownerNameController.dispose();
    _genderController.dispose();
    _contactController.dispose();
    _schoolIdController.dispose();
    _departmentController.dispose();
    _yearLevelController.dispose();
    _blockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final genderOptions = [
      OptionItem(label: 'Male', icon: Icons.male, value: 'male'),
      OptionItem(label: 'Female', icon: Icons.female, value: 'female'),
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
            'Owner Information',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          Text(
            'Please provide the vehicle owner\'s personal details',
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
                  label: 'Owner Name',
                  controller: _ownerNameController,
                  borderColor: AppColors.primary,
                ),
              ),
              const Spacing.horizontal(size: AppSpacing.large),
              Expanded(
                child: CustDropDown(
                  hintText: "College",
                  items: const [
                    CustDropdownMenuItem(
                      value: 'CCS',
                      child: Text(
                        "CCS",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'LHS',
                      child: Text(
                        "LHS",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'CTED',
                      child: Text(
                        "CTED",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'CBA',
                      child: Text(
                        "CBA",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'CAF-SOE',
                      child: Text("CAF-SOE"),
                    ),
                    CustDropdownMenuItem(value: 'SCJE', child: Text("SCJE")),
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
                child: CustomTextField2(
                  label: 'Contact',
                  controller: _contactController,
                  borderColor: AppColors.primary,
                ),
              ),
              const Spacing.horizontal(size: AppSpacing.large),
              Expanded(
                child: CustDropDown(
                  hintText: "Year Level",
                  items: const [
                    CustDropdownMenuItem(
                      value: '1st',
                      child: Text(
                        "1st",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: '2nd',
                      child: Text(
                        "2nd",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: '3rd',
                      child: Text(
                        "3rd",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: '4th',
                      child: Text(
                        "4th",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'Junior High School',
                      child: Text("Junior High School"),
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
          // Row 3: Department & Year Level
          Row(
            children: [
              Expanded(
                child: CustomTextField2(
                  label: 'School ID',
                  controller: _schoolIdController,
                  borderColor: AppColors.primary,
                ),
              ),
              const Spacing.horizontal(size: AppSpacing.large),
              Expanded(
                child: CustDropDown(
                  hintText: "Block",
                  items: const [
                    CustDropdownMenuItem(
                      value: 'A',
                      child: Text(
                        "A",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'B',
                      child: Text(
                        "B",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'C',
                      child: Text(
                        "C",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(
                      value: 'D',
                      child: Text(
                        "D",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                    CustDropdownMenuItem(value: 'E', child: Text("E")),
                    CustDropdownMenuItem(value: 'F', child: Text("F")),
                    CustDropdownMenuItem(value: 'G', child: Text("G")),
                    CustDropdownMenuItem(value: 'H', child: Text("H")),
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

          // Gender
          CustDropDown(
            hintText: "Gender",
            items: const [
              CustDropdownMenuItem(
                value: 'Male',
                child: Text(
                  "Male",
                  style: TextStyle(fontSize: AppFontSizes.small),
                ),
              ),
              CustDropdownMenuItem(
                value: 'Female',
                child: Text(
                  "Female",
                  style: TextStyle(fontSize: AppFontSizes.small),
                ),
              ),
            ],

            borderRadius: 5,
            onChanged: (val) {
              debugPrint(val.toString()); //to be removed
            },
          ),
        ],
      ),
    );
  }
}
