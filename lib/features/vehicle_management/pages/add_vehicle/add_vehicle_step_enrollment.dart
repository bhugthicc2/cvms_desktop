import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown2.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_form_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/utils/academic_year_utils.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/texts/content_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnrollmentStepContent extends StatefulWidget {
  final double horizontalPadding;
  const EnrollmentStepContent({super.key, required this.horizontalPadding});

  @override
  State<EnrollmentStepContent> createState() => _EnrollmentStepContentState();
}

class _EnrollmentStepContentState extends State<EnrollmentStepContent> {
  late final TextEditingController _academicYearController;
  late final TextEditingController _semesterController;

  String? _selectedAcademicYear;
  String? _selectedSemester;

  // Error state variables
  String? _academicYearError;
  String? _semesterError;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Academic year options (2024-2025 to 2030-2031)
  late final List<String> _academicYearOptions;

  // Semester options
  static const List<String> _semesterOptions = [
    '1st Semester',
    '2nd Semester',
    '3rd Semester',
    '4th Semester',
  ];

  @override
  void initState() {
    super.initState();

    _academicYearOptions = AcademicYearUtils.generate(
      pastYears: 2,
      futureYears: 3,
    );

    _academicYearController = TextEditingController();
    _semesterController = TextEditingController();

    final formData = context.read<VehicleFormCubit>().formData;

    if (formData.academicYear != null) {
      _selectedAcademicYear = formData.academicYear;
      _academicYearController.text = formData.academicYear!;
    } else {
      // Set current academic year as default
      _selectedAcademicYear = AcademicYearUtils.format(
        AcademicYearUtils.currentStartYear(),
      );
      _academicYearController.text = _selectedAcademicYear!;
    }

    if (formData.semester != null) {
      _selectedSemester = formData.semester;
      _semesterController.text = formData.semester!;
    }
  }

  @override
  void dispose() {
    _academicYearController.dispose();
    _semesterController.dispose();
    super.dispose();
  }

  // Expose validation method
  bool validate() {
    setState(() {
      // Clear previous errors
      _academicYearError = null;
      _semesterError = null;

      // Validate academic year
      if (_selectedAcademicYear == null || _selectedAcademicYear!.isEmpty) {
        _academicYearError = 'Academic year is required';
      } else {
        // Validate academic year format (YYYY-YYYY)
        if (_selectedAcademicYear == null || _selectedAcademicYear!.isEmpty) {
          _academicYearError = 'Academic year is required';
        } else if (!AcademicYearUtils.isValid(_selectedAcademicYear!)) {
          _academicYearError = 'Invalid academic year format';
        }
      }

      // Validate semester
      if (_selectedSemester == null || _selectedSemester!.isEmpty) {
        _semesterError = 'Semester is required';
      } else if (!_semesterOptions.contains(_selectedSemester)) {
        _semesterError = 'Invalid semester selection';
      }
    });

    return _academicYearError == null && _semesterError == null;
  }

  void _updateFormData() {
    context.read<VehicleFormCubit>().updateEnrollmentInfo(
      academicYear: _selectedAcademicYear,
      semester: _selectedSemester,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.vertical(size: AppSpacing.large),
            const ContentTitle(
              title: 'Enrollment Details',
              subtitle: 'Please provide academic enrollment information',
            ),
            Spacing.vertical(size: AppSpacing.large),

            // Academic Year Field
            CustDropDown(
              labelText: 'Academic Year Enrolled',
              hintText: 'Select Academic Year',
              defaultSelectedIndex: _getAcademicYearIndex(
                _selectedAcademicYear,
              ),
              errorText: _academicYearError,
              items:
                  _academicYearOptions.map((year) {
                    return CustDropdownMenuItem(
                      value: year,
                      child: Text(
                        year,
                        style: const TextStyle(fontSize: AppFontSizes.small),
                      ),
                    );
                  }).toList(),
              borderRadius: 5,
              onChanged: (value) {
                setState(() {
                  _selectedAcademicYear = value;
                  _academicYearController.text = value ?? '';
                  _academicYearError = null;
                });
                _updateFormData();
              },
            ),
            Spacing.vertical(size: AppSpacing.medium),

            // Semester Field
            CustDropDown(
              labelText: 'Semester Enrolled',
              hintText: 'Select Semester',
              defaultSelectedIndex: _getSemesterIndex(_selectedSemester),
              errorText: _semesterError,
              items:
                  _semesterOptions.map((semester) {
                    return CustDropdownMenuItem(
                      value: semester,
                      child: Text(
                        semester,
                        style: const TextStyle(fontSize: AppFontSizes.small),
                      ),
                    );
                  }).toList(),
              borderRadius: 5,
              onChanged: (value) {
                setState(() {
                  _selectedSemester = value;
                  _semesterController.text = value ?? '';
                  _semesterError = null;
                });
                _updateFormData();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for dropdown index calculation
  int _getAcademicYearIndex(String? value) {
    if (value == null) return 0;
    return _academicYearOptions.indexOf(value);
  }

  int _getSemesterIndex(String? value) {
    if (value == null) return 0;
    return _semesterOptions.indexOf(value);
  }
}
