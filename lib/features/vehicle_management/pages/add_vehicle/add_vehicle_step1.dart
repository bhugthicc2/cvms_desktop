import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown2.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field2.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_form_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/texts/content_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnerStepContent extends StatefulWidget {
  final double horizontalPadding;
  const OwnerStepContent({super.key, required this.horizontalPadding});

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

  String? _selectedGender;
  String? _selectedCollege;
  String? _selectedYearLevel;
  String? _selectedBlock;

  // Error state variables
  String? _ownerNameError;
  String? _genderError;
  String? _contactError;
  String? _schoolIdError;
  String? _collegeError;
  String? _yearLevelError;
  String? _blockError;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Expose validation method
  bool validate() {
    setState(() {
      // Clear previous errors
      _ownerNameError = null;
      _genderError = null;
      _contactError = null;
      _schoolIdError = null;
      _collegeError = null;
      _yearLevelError = null;
      _blockError = null;

      // Validate owner name
      if (_ownerNameController.text.trim().isEmpty) {
        _ownerNameError = 'Owner name is required';
      }

      // Validate gender
      if (_selectedGender == null) {
        _genderError = 'Please select a gender';
      }

      // Validate contact
      if (_contactController.text.trim().isEmpty) {
        _contactError = 'Contact number is required';
      }

      // Validate school ID
      if (_schoolIdController.text.trim().isEmpty) {
        _schoolIdError = 'School ID is required';
      }

      // Validate college
      if (_selectedCollege == null) {
        _collegeError = 'Please select a college';
      }

      // Validate year level
      if (_selectedYearLevel == null) {
        _yearLevelError = 'Please select a year level';
      }

      // Validate block
      if (_selectedBlock == null) {
        _blockError = 'Please select a block';
      }
    });

    // Return true if no errors
    return _ownerNameError == null &&
        _genderError == null &&
        _contactError == null &&
        _schoolIdError == null &&
        _collegeError == null &&
        _yearLevelError == null &&
        _blockError == null;
  }

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

    // Initialize controllers with existing data
    final formData = context.read<VehicleFormCubit>().formData;
    _ownerNameController.text = formData.ownerName ?? '';
    _contactController.text = formData.contact ?? '';
    _schoolIdController.text = formData.schoolId ?? '';
    _selectedGender = formData.gender;
    _selectedCollege = formData.college;
    _selectedYearLevel = formData.yearLevel;
    _selectedBlock = formData.block;

    // Add listeners to sync with cubit
    _ownerNameController.addListener(_onOwnerNameChanged);
    _contactController.addListener(_onContactChanged);
    _schoolIdController.addListener(_onSchoolIdChanged);
  }

  void _onOwnerNameChanged() {
    context.read<VehicleFormCubit>().updateStep1(
      ownerName: _ownerNameController.text,
    );
  }

  void _onContactChanged() {
    context.read<VehicleFormCubit>().updateStep1(
      contact: _contactController.text,
    );
  }

  void _onSchoolIdChanged() {
    context.read<VehicleFormCubit>().updateStep1(
      schoolId: _schoolIdController.text,
    );
  }

  void _onCollegeChanged(String? value) {
    setState(() {
      _selectedCollege = value;
      _collegeError = null; // Clear error when user makes selection
    });
    context.read<VehicleFormCubit>().updateStep1(college: value);
  }

  int _getCollegeIndex(String? value) {
    const colleges = ['CCS', 'LHS', 'CTED', 'CBA', 'CAF-SOE', 'SCJE'];
    return colleges.indexOf(value ?? '');
  }

  void _onYearLevelChanged(String? value) {
    setState(() {
      _selectedYearLevel = value;
      _yearLevelError = null; // Clear error when user makes selection
    });
    context.read<VehicleFormCubit>().updateStep1(yearLevel: value);
  }

  int _getYearLevelIndex(String? value) {
    const yearLevels = ['1st', '2nd', '3rd', '4th', 'Junior High School'];
    return yearLevels.indexOf(value ?? '');
  }

  void _onBlockChanged(String? value) {
    setState(() {
      _selectedBlock = value;
      _blockError = null; // Clear error when user makes selection
    });
    context.read<VehicleFormCubit>().updateStep1(block: value);
  }

  int _getBlockIndex(String? value) {
    const blocks = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    return blocks.indexOf(value ?? '');
  }

  void _onGenderChanged(String? value) {
    setState(() {
      _selectedGender = value;
      _genderError = null; // Clear error when user makes selection
    });
    context.read<VehicleFormCubit>().updateStep1(gender: value);
  }

  int _getGenderIndex(String? value) {
    const genders = ['Male', 'Female'];
    return genders.indexOf(value ?? '');
  }

  @override
  void dispose() {
    _ownerNameController.removeListener(_onOwnerNameChanged);
    _contactController.removeListener(_onContactChanged);
    _schoolIdController.removeListener(_onSchoolIdChanged);
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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.horizontalPadding,
        vertical: AppSpacing.large,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContentTitle(
              title: 'Owner Information',
              subtitle: 'Please provide the vehicle owner\'s personal details',
            ),

            const Spacing.vertical(size: AppSpacing.large),
            // Row 1: Owner Name & Gender
            Row(
              children: [
                Expanded(
                  child: CustomTextField2(
                    hintTxt: 'ex. Juan Dela Cruz',
                    label: 'Owner Name',
                    controller: _ownerNameController,
                    borderColor: AppColors.primary,
                    errorText: _ownerNameError,
                  ),
                ),
                const Spacing.horizontal(size: AppSpacing.large),
                Expanded(
                  child: CustDropDown(
                    hintText: "College",
                    defaultSelectedIndex: _getCollegeIndex(_selectedCollege),
                    errorText: _collegeError,
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
                    onChanged: _onCollegeChanged,
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
                    hintTxt: 'ex. 09651144639',
                    label: 'Contact',
                    controller: _contactController,
                    borderColor: AppColors.primary,
                    errorText: _contactError,
                  ),
                ),
                const Spacing.horizontal(size: AppSpacing.large),
                Expanded(
                  child: CustDropDown(
                    hintText: "Year Level",
                    defaultSelectedIndex: _getYearLevelIndex(
                      _selectedYearLevel,
                    ),
                    errorText: _yearLevelError,
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
                    onChanged: _onYearLevelChanged,
                  ),
                ),
              ],
            ),
            const Spacing.vertical(size: AppSpacing.medium),
            // Row 3: School ID & Block
            Row(
              children: [
                Expanded(
                  child: CustomTextField2(
                    hintTxt: 'ex. KC-28-A-11275',
                    label: 'School ID',
                    controller: _schoolIdController,
                    borderColor: AppColors.primary,
                    errorText: _schoolIdError,
                  ),
                ),
                const Spacing.horizontal(size: AppSpacing.large),
                Expanded(
                  child: CustDropDown(
                    hintText: "Block",
                    defaultSelectedIndex: _getBlockIndex(_selectedBlock),
                    errorText: _blockError,
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
                    onChanged: _onBlockChanged,
                  ),
                ),
              ],
            ),
            const Spacing.vertical(size: AppSpacing.medium),

            // Gender
            CustDropDown(
              hintText: "Gender",
              defaultSelectedIndex: _getGenderIndex(_selectedGender),
              errorText: _genderError,
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
              onChanged: _onGenderChanged,
            ),
          ],
        ),
      ),
    );
  }
}
