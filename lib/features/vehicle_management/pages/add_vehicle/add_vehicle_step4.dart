import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field2.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/address_state.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_form_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/controllers/address_controller.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/widgets/location_dropdowns.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/texts/content_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressStepContent extends StatefulWidget {
  final double horizontalPadding;
  const AddressStepContent({super.key, required this.horizontalPadding});

  @override
  State<AddressStepContent> createState() => _AddressStepContentState();
}

class _AddressStepContentState extends State<AddressStepContent> {
  late final TextEditingController _purokController;
  late final AddressController _addressController;
  AddressState? _currentState;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Expose validation method
  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  void initState() {
    super.initState();
    _purokController = TextEditingController();

    _addressController = AddressController(
      onStateChanged: (newState) {
        setState(() {
          _currentState = newState;
          // Sync to VehicleFormCubit
          context.read<VehicleFormCubit>().updateStep4(
            region: newState.selectedRegionId,
            province: newState.selectedProvinceName,
            municipality: newState.selectedMunicipalityName,
            barangay: newState.selectedBarangay,
            purokStreet: _purokController.text,
          );
        });
      },
    );

    // Initialize with existing data from VehicleFormCubit
    final formData = context.read<VehicleFormCubit>().formData;
    final initialState = AddressState(
      selectedRegionId: formData.region,
      selectedProvinceName: formData.province,
      selectedMunicipalityName: formData.municipality,
      selectedBarangay: formData.barangay,
    );
    _addressController.initializeState(initialState);
    _currentState = initialState;

    // Initialize purok controller with existing data
    _purokController.text = formData.purokStreet ?? '';

    // Add listener to update state when purok changes
    _purokController.addListener(() {
      context.read<VehicleFormCubit>().updateStep4(
        region: _currentState?.selectedRegionId,
        province: _currentState?.selectedProvinceName,
        municipality: _currentState?.selectedMunicipalityName,
        barangay: _currentState?.selectedBarangay,
        purokStreet: _purokController.text,
      );
    });
  }

  @override
  void dispose() {
    _purokController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentState == null) {
      return const SizedBox.shrink();
    }

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
              title: 'Address Information',
              subtitle: 'Please provide the owner\'s address details',
            ),

            const Spacing.vertical(size: AppSpacing.large),

            // Location dropdowns separated into their own widget
            LocationDropdowns(
              regionItems: _addressController.regionItems,
              provinceItems: _addressController.provinceItems,
              municipalityItems: _addressController.municipalityItems,
              barangayItems: _addressController.barangayItems,
              selectedRegionId: _currentState!.selectedRegionId,
              selectedProvinceName: _currentState!.selectedProvinceName,
              selectedMunicipalityName: _currentState!.selectedMunicipalityName,
              selectedBarangay: _currentState!.selectedBarangay,
              onRegionChanged: _addressController.onRegionChanged,
              onProvinceChanged: _addressController.onProvinceChanged,
              onMunicipalityChanged: _addressController.onMunicipalityChanged,
              onBarangayChanged: _addressController.onBarangayChanged,
            ),

            const Spacing.vertical(size: AppSpacing.medium),

            // Purok/Street field
            CustomTextField2(
              label: 'Purok/Street',
              hintTxt: 'ex. Saging, Dos, etc.',
              controller: _purokController,
              borderColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
