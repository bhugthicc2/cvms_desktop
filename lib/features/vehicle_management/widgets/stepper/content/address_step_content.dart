import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field2.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/controllers/address_controller.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/address_state.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/widgets/location_dropdowns.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/stepper/texts/content_title.dart';
import 'package:flutter/material.dart';

class AddressStepContent extends StatefulWidget {
  final double horizontalPadding;
  final AddressState? initialState;

  const AddressStepContent({
    super.key,
    required this.horizontalPadding,
    this.initialState,
  });

  @override
  State<AddressStepContent> createState() => _AddressStepContentState();
}

class _AddressStepContentState extends State<AddressStepContent> {
  late final TextEditingController _purokController;
  late final AddressController _addressController;
  AddressState? _currentState;

  @override
  void initState() {
    super.initState();
    _purokController = TextEditingController();

    _addressController = AddressController(
      onStateChanged: (newState) {
        setState(() {
          _currentState = newState;
        });
      },
    );

    // Initialize with provided state or default
    final initialState = widget.initialState ?? AddressState();
    _addressController.initializeState(initialState);

    // Initialize purok controller with existing value
    _purokController.text = initialState.purokStreet;

    // Add listener to update state when purok changes
    _purokController.addListener(() {
      _addressController.onPurokStreetChanged(_purokController.text);
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContentTitle(
            title: 'Address',
            subtitle: 'Please provide the address details',
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
            controller: _purokController,
            borderColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  // Public method to get current address state
  AddressState getCurrentAddressState() {
    return _currentState ?? AddressState();
  }
}
