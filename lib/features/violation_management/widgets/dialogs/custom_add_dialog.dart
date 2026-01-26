import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown_field.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/app/typeahead_search_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_enums.dart';
import 'package:cvms_desktop/features/violation_management/widgets/texts/custom_txt_field_label.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomAddDialog extends StatelessWidget {
  final String title;
  final VoidCallback onSubmit;

  // Vehicle search
  final bool showVehicleSearch;
  final String searchFieldLabel;
  final TextEditingController vehicleController;
  final Future<List<VehicleEntry>> Function(String) searchVehicles;
  final String Function(VehicleEntry) getVehicleSuggestion;
  final void Function(VehicleEntry) onVehicleSelected;

  // Status
  final bool showStatusDropdown;
  final String statusFieldLabel;
  final ViolationStatus? selectedStatus;
  final List<DropdownItem<ViolationStatus>> violationStatusItems;
  final void Function(ViolationStatus?) onSelectedStatusChange;

  // Violation Type
  final bool showViolationType;
  final String violationTypeFieldLabel;
  final String? selectedViolationType;
  final List<DropdownItem<String>> violationTypeItems;
  final void Function(String?) onSelectedViolationTypeChange;

  // Others
  final bool showOtherField;
  final TextEditingController othersController;

  const CustomAddDialog({
    super.key,
    required this.title,
    required this.onSubmit,

    // vehicle
    required this.vehicleController,
    required this.searchVehicles,
    required this.getVehicleSuggestion,
    required this.onVehicleSelected,
    this.showVehicleSearch = true,
    this.searchFieldLabel = 'Vehicle',

    // status
    this.showStatusDropdown = false,
    this.statusFieldLabel = 'Status',
    this.selectedStatus,
    this.violationStatusItems = const [],
    required this.onSelectedStatusChange,

    // violation type
    this.showViolationType = true,
    this.violationTypeFieldLabel = 'Violation Type',
    this.selectedViolationType,
    this.violationTypeItems = const [],
    required this.onSelectedViolationTypeChange,

    // others
    this.showOtherField = true,
    required this.othersController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      btnTxt: 'Save',
      onSubmit: onSubmit,
      title: title,
      height: 500,
      width: 700,
      icon: PhosphorIconsBold.warning,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacing.vertical(size: AppSpacing.large),

            // Vehicle Search
            if (showVehicleSearch) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTxtFieldLabel(
                  isRequired: true,
                  labelText: searchFieldLabel,
                ),
              ),
              Spacing.vertical(size: AppSpacing.small),
              TypeaheadSearchField<VehicleEntry>(
                controller: vehicleController,
                hintText: 'Search plate, owner, or school ID',
                suggestionsCallback: searchVehicles,
                getSuggestionText: getVehicleSuggestion,
                onSuggestionSelected: onVehicleSelected,
                searchFieldWidth: double.infinity,
                searchFieldHeight: 50,
                borderOpacity: 1,
                hasShadow: false,
                hoverScale: 1,
                borderRadii: 6,
              ),
              Spacing.vertical(size: AppIconSizes.medium),
            ],

            // Status
            if (showStatusDropdown) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTxtFieldLabel(
                  isRequired: true,
                  labelText: statusFieldLabel,
                ),
              ),
              Spacing.vertical(size: AppIconSizes.xSmall),
              CustomDropdownField<ViolationStatus>(
                value: selectedStatus,
                hintText: 'Select Status',
                items: violationStatusItems,
                onChanged: onSelectedStatusChange,
              ),
              Spacing.vertical(size: AppIconSizes.medium),
            ],

            // Violation Type
            if (showViolationType) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTxtFieldLabel(
                  isRequired: true,
                  labelText: violationTypeFieldLabel,
                ),
              ),
              Spacing.vertical(size: AppIconSizes.xSmall),
              CustomDropdownField<String>(
                value: selectedViolationType,
                hintText: 'Select Violation',
                items: violationTypeItems,
                onChanged: onSelectedViolationTypeChange,
              ),
              Spacing.vertical(size: AppIconSizes.medium),
            ],

            // Others
            if (showOtherField && selectedViolationType == 'Other') ...[
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTxtFieldLabel(
                  isRequired: true,
                  labelText: 'Please specify',
                ),
              ),
              Spacing.vertical(size: AppIconSizes.xSmall),
              CustomTextField(
                controller: othersController,
                labelText: 'Other details',
                height: 80,
                maxLines: 3,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
