import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/core/constants/registration_policy.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field2.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_form_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/texts/content_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationStepContent extends StatefulWidget {
  final double horizontalPadding;
  const RegistrationStepContent({super.key, required this.horizontalPadding});

  @override
  State<RegistrationStepContent> createState() =>
      _RegistrationStepContentState();
}

class _RegistrationStepContentState extends State<RegistrationStepContent> {
  late final TextEditingController _registrationDateController;
  DateTime? _selectedRegistrationDate;
  Timestamp? _registrationValidFrom;
  Timestamp? _registrationValidUntil;

  // Error state variables
  String? _registrationDateError;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _registrationDateController = TextEditingController();

    // Set default to today's date
    _selectedRegistrationDate = DateTime.now();
    _registrationDateController.text = _formatDate(_selectedRegistrationDate!);
    _calculateRegistrationValidity();
  }

  @override
  void dispose() {
    _registrationDateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _calculateRegistrationValidity() {
    if (_selectedRegistrationDate != null) {
      _registrationValidFrom = Timestamp.fromDate(_selectedRegistrationDate!);

      // Calculate valid until date based on policy
      final validUntil = _selectedRegistrationDate!.add(
        Duration(days: kTempRegistrationValidityDays),
      );
      _registrationValidUntil = Timestamp.fromDate(validUntil);

      // Update form data
      context.read<VehicleFormCubit>().updateStep5(
        registrationValidFrom: _registrationValidFrom,
        registrationValidUntil: _registrationValidUntil,
      );
    }
  }

  Future<void> _selectRegistrationDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedRegistrationDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(
        const Duration(days: 30),
      ), // Allow future dates up to 30 days
    );

    if (picked != null && picked != _selectedRegistrationDate) {
      setState(() {
        _selectedRegistrationDate = picked;
        _registrationDateController.text = _formatDate(picked);
        _registrationDateError = null;
      });
      _calculateRegistrationValidity();
    }
  }

  // Expose validation method
  bool validate() {
    setState(() {
      _registrationDateError = null;
    });

    if (_selectedRegistrationDate == null) {
      setState(() {
        _registrationDateError = 'Registration date is required';
      });
      return false;
    }

    return true;
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
              title: 'Registration Information',
              subtitle: 'Set the registration validity period for this vehicle',
            ),

            const Spacing.vertical(size: AppSpacing.medium),

            // Registration Date Field
            GestureDetector(
              onTap: _selectRegistrationDate,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        _registrationDateError != null
                            ? AppColors.error
                            : AppColors.greySurface,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField2(
                        controller: _registrationDateController,
                        label: 'MVP Registration Date',
                        hintTxt: 'Select registration date',
                        errorText: _registrationDateError,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacing.vertical(size: AppSpacing.medium),

            // Registration Validity Information
            if (_registrationValidFrom != null &&
                _registrationValidUntil != null)
              Container(
                padding: const EdgeInsets.all(AppSpacing.medium),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Registration Validity Period',
                          style: TextStyle(
                            fontSize: AppFontSizes.medium,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildValidityRow(
                      'Valid From:',
                      _formatTimestamp(_registrationValidFrom!),
                    ),
                    const SizedBox(height: 8),
                    _buildValidityRow(
                      'Valid Until:',
                      _formatTimestamp(_registrationValidUntil!),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Duration: $kTempRegistrationValidityDays days (1 year)',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: AppColors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

            const Spacing.vertical(size: AppSpacing.large),

            // Policy Information
            Container(
              padding: const EdgeInsets.all(AppSpacing.medium),
              decoration: BoxDecoration(
                color: AppColors.greySurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registration Policy',
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vehicle registration is valid for one year from the registration date or until the registration\'s affiliation with the university ends, whether due to graduation, resignation, retirement, dismissal, or transfer.',
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      color: AppColors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidityRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              fontWeight: FontWeight.w500,
              color: AppColors.grey,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.small,
              fontWeight: FontWeight.bold,
              color: AppColors.black.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.month}/${date.day}/${date.year}';
  }
}
