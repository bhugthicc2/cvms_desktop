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

class VehicleStepContent extends StatefulWidget {
  final double horizontalPadding;
  const VehicleStepContent({super.key, required this.horizontalPadding});

  @override
  State<VehicleStepContent> createState() => _VehicleStepContentState();
}

class _VehicleStepContentState extends State<VehicleStepContent> {
  late final TextEditingController _plateNumberController;
  late final TextEditingController _vehicleModelController;
  late final TextEditingController _vehicleColorController;

  String? _selectedVehicleType;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Expose validation method
  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  void initState() {
    super.initState();
    _plateNumberController = TextEditingController();
    _vehicleModelController = TextEditingController();
    _vehicleColorController = TextEditingController();

    // Initialize controllers with existing data
    final formData = context.read<VehicleFormCubit>().formData;
    _plateNumberController.text = formData.plateNumber ?? '';
    _vehicleModelController.text = formData.vehicleModel ?? '';
    _vehicleColorController.text = formData.vehicleColor ?? '';
    _selectedVehicleType = formData.vehicleType;

    // Add listeners to sync with cubit
    _plateNumberController.addListener(_onPlateNumberChanged);
    _vehicleModelController.addListener(_onVehicleModelChanged);
    _vehicleColorController.addListener(_onVehicleColorChanged);
  }

  void _onPlateNumberChanged() {
    context.read<VehicleFormCubit>().updateStep2(
      plateNumber: _plateNumberController.text,
    );
  }

  void _onVehicleModelChanged() {
    context.read<VehicleFormCubit>().updateStep2(
      vehicleModel: _vehicleModelController.text,
    );
  }

  void _onVehicleColorChanged() {
    context.read<VehicleFormCubit>().updateStep2(
      vehicleColor: _vehicleColorController.text,
    );
  }

  void _onVehicleTypeChanged(String? value) {
    setState(() {
      _selectedVehicleType = value;
    });
    context.read<VehicleFormCubit>().updateStep2(vehicleType: value);
  }

  int _getVehicleTypeIndex(String? value) {
    const vehicleTypes = ['Two-wheeled', 'Four-wheeled', 'Other'];
    return vehicleTypes.indexOf(value ?? '');
  }

  @override
  void dispose() {
    _plateNumberController.removeListener(_onPlateNumberChanged);
    _vehicleModelController.removeListener(_onVehicleModelChanged);
    _vehicleColorController.removeListener(_onVehicleColorChanged);
    _plateNumberController.dispose();
    _vehicleModelController.dispose();
    _vehicleColorController.dispose();
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
              title: 'Vehicle Information',
              subtitle: 'Please provide the vehicle specification details',
            ),

            const Spacing.vertical(size: AppSpacing.large),
            // Row 1: Plate Number & Vehicle Model
            Row(
              children: [
                Expanded(
                  child: CustomTextField2(
                    hintTxt: 'Plate Number',
                    label: 'Plate number',
                    controller: _plateNumberController,
                    borderColor: AppColors.primary,
                    errorText:
                        _formKey.currentState?.validate() == false
                            ? 'Plate number is required'
                            : null,
                  ),
                ),
                const Spacing.horizontal(size: AppSpacing.large),
                Expanded(
                  child: CustomTextField2(
                    hintTxt: 'ex. Honda Beat',
                    label: 'Vehicle Model',
                    controller: _vehicleModelController,
                    borderColor: AppColors.primary,
                    errorText:
                        _formKey.currentState?.validate() == false
                            ? 'Vehicle model is required'
                            : null,
                  ),
                ),
              ],
            ),
            const Spacing.vertical(size: AppSpacing.medium),
            // Row 2: Vehicle Color & Vehicle Type
            Row(
              children: [
                Expanded(
                  child: CustomTextField2(
                    hintTxt: 'ex. Red',
                    label: 'Vehicle Color',
                    controller: _vehicleColorController,
                    borderColor: AppColors.primary,
                    errorText:
                        _formKey.currentState?.validate() == false
                            ? 'Vehicle color is required'
                            : null,
                  ),
                ),
                const Spacing.horizontal(size: AppSpacing.large),
                Expanded(
                  child: CustDropDown(
                    labelText: 'Vehicle type',
                    hintText: "Vehicle type",
                    defaultSelectedIndex: _getVehicleTypeIndex(
                      _selectedVehicleType,
                    ),
                    errorText:
                        _selectedVehicleType == null
                            ? 'Please select a vehicle type'
                            : null,
                    items: const [
                      CustDropdownMenuItem(
                        value: 'two-wheeled',
                        child: Text(
                          "Two-wheeled",
                          style: TextStyle(fontSize: AppFontSizes.small),
                        ),
                      ),
                      CustDropdownMenuItem(
                        value: 'four-wheeled',
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
                    onChanged: _onVehicleTypeChanged,
                  ),
                ),
              ],
            ),
            const Spacing.vertical(size: AppSpacing.medium),
          ],
        ),
      ),
    );
  }
}
