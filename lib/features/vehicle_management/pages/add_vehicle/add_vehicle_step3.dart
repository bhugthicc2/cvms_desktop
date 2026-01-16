import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field2.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_form_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/texts/content_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Error state variables
  String? _licenseNumberError;
  String? _orNumberError;
  String? _crNumberError;

  // Expose validation method
  bool validate() {
    setState(() {
      _licenseNumberError =
          _licenseNumberController.text.isEmpty
              ? 'License number is required'
              : null;
      _orNumberError =
          _orNumberController.text.isEmpty ? 'OR number is required' : null;
      _crNumberError =
          _crNumberController.text.isEmpty ? 'CR number is required' : null;
    });

    return _formKey.currentState?.validate() ?? false;
  }

  @override
  void initState() {
    super.initState();
    _licenseNumberController = TextEditingController();
    _orNumberController = TextEditingController();
    _crNumberController = TextEditingController();

    // Initialize controllers with existing data
    final formData = context.read<VehicleFormCubit>().formData;
    _licenseNumberController.text = formData.licenseNumber ?? '';
    _orNumberController.text = formData.orNumber ?? '';
    _crNumberController.text = formData.crNumber ?? '';

    // Add listeners to sync with cubit
    _licenseNumberController.addListener(_onLicenseNumberChanged);
    _orNumberController.addListener(_onOrNumberChanged);
    _crNumberController.addListener(_onCrNumberChanged);
  }

  void _onLicenseNumberChanged() {
    if (_licenseNumberError != null) {
      setState(() {
        _licenseNumberError = null;
      });
    }
    context.read<VehicleFormCubit>().updateStep3(
      licenseNumber: _licenseNumberController.text,
    );
  }

  void _onOrNumberChanged() {
    if (_orNumberError != null) {
      setState(() {
        _orNumberError = null;
      });
    }
    context.read<VehicleFormCubit>().updateStep3(
      orNumber: _orNumberController.text,
    );
  }

  void _onCrNumberChanged() {
    if (_crNumberError != null) {
      setState(() {
        _crNumberError = null;
      });
    }
    context.read<VehicleFormCubit>().updateStep3(
      crNumber: _crNumberController.text,
    );
  }

  @override
  void dispose() {
    _licenseNumberController.removeListener(_onLicenseNumberChanged);
    _orNumberController.removeListener(_onOrNumberChanged);
    _crNumberController.removeListener(_onCrNumberChanged);
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContentTitle(
              title: 'Legal Details',
              subtitle: 'Please provide the legal vehicle details',
            ),

            const Spacing.vertical(size: AppSpacing.large),
            // Row 1: OR Number & CR Number
            Row(
              children: [
                Expanded(
                  child: CustomTextField2(
                    hintTxt: 'OR Number',
                    label: 'OR Number',
                    controller: _orNumberController,
                    borderColor: AppColors.primary,
                    errorText: _orNumberError,
                  ),
                ),
                const Spacing.horizontal(size: AppSpacing.large),
                Expanded(
                  child: CustomTextField2(
                    hintTxt: 'CR Number',
                    label: 'CR Number',
                    controller: _crNumberController,
                    borderColor: AppColors.primary,
                    errorText: _crNumberError,
                  ),
                ),
              ],
            ),

            const Spacing.vertical(size: AppSpacing.medium),
            CustomTextField2(
              hintTxt: 'License Number',
              label: 'License Number',
              controller: _licenseNumberController,
              borderColor: AppColors.primary,
              errorText: _licenseNumberError,
            ),
          ],
        ),
      ),
    );
  }
}
