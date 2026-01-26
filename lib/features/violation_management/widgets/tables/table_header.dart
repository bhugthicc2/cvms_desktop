import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown_field.dart';
import 'package:cvms_desktop/core/widgets/app/search_field.dart';
import 'package:cvms_desktop/core/widgets/app/typeahead_search_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/vehicle_search_suggestion.dart';
import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_enums.dart';
import 'package:cvms_desktop/features/violation_management/widgets/buttons/custom_violation_button.dart';
import 'package:cvms_desktop/features/violation_management/widgets/dialogs/custom_add_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TableHeader extends StatelessWidget {
  final TextEditingController vehicleController;
  final TextEditingController violationController;
  final List<String>? fieldLabels;
  final bool showVehicleSearch;
  final bool showStatusDropdown;
  final bool showViolationType;
  final bool showOtherField;
  final String? searchFieldLabelText;
  final String? statusFieldLabelText;
  final String? violationTypeFieldLabelText;
  final Function(Map<String, dynamic>)? onAddViolation;
  final Function(Map<String, dynamic>)? defaultSubmitHandler;
  final Future<List<VehicleSearchSuggestion>> Function(String)
  onSearchSuggestions;
  final void Function(VehicleSearchSuggestion) onVehicleSelected;
  final VoidCallback onSubmit;
  final void Function(ViolationStatus?) onSelectedStatusChange;

  final void Function(String?) onSelectedViolationTypeChange;
  final TextEditingController othersController;
  final ViolationStatus? selectedStatus;
  final String? selectedViolationType;
  final List<DropdownItem<String>> violationTypeItems;
  final List<DropdownItem<ViolationStatus>> violationStatusItems;

  const TableHeader({
    super.key,
    required this.vehicleController,
    required this.violationController,
    this.fieldLabels,
    this.showVehicleSearch = true,
    this.showStatusDropdown = true,
    this.showViolationType = true,
    this.showOtherField = true,
    this.searchFieldLabelText,
    this.statusFieldLabelText,
    this.violationTypeFieldLabelText,
    this.onAddViolation,
    this.defaultSubmitHandler,
    required this.onSearchSuggestions,
    required this.onVehicleSelected,
    required this.onSubmit,
    required this.onSelectedStatusChange,
    required this.onSelectedViolationTypeChange,
    required this.othersController,
    this.selectedStatus,
    this.selectedViolationType,
    this.violationTypeItems = const [],
    this.violationStatusItems = const [],
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationCubit, ViolationState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: SearchField(controller: violationController),
              ),
            ),
            Spacing.horizontal(size: AppSpacing.medium),
            Expanded(
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        items: [
                          'All',
                          '12-23-2024',
                          '12-23-2025',
                        ], //todo implement proper date filtering function
                        initialValue: 'All',
                        onChanged: (value) {
                          context.read<ViolationCubit>().filterByDate(value);
                        },
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    Expanded(
                      child: CustomViolationButton(
                        textColor:
                            state.isBulkModeEnabled
                                ? AppColors.white
                                : AppColors.black,
                        label:
                            state.isBulkModeEnabled
                                ? "Exit Bulk Mode"
                                : "Bulk Mode",
                        backgroundColor:
                            state.isBulkModeEnabled
                                ? AppColors.warning
                                : AppColors.white,
                        onPressed: () {
                          context.read<ViolationCubit>().toggleBulkMode();
                        },
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    Expanded(
                      child: CustomViolationButton(
                        label: "Add Violation",
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (_) => CustomAddDialog(
                                  title: 'Report Violation',
                                  onSubmit: onSubmit,
                                  vehicleController: vehicleController,
                                  searchVehicles: onSearchSuggestions,
                                  getVehicleSuggestion:
                                      (suggestion) =>
                                          '${suggestion.plateNumber} - ${suggestion.ownerName}',
                                  onVehicleSelected: onVehicleSelected,
                                  onSelectedStatusChange:
                                      onSelectedStatusChange,
                                  onSelectedViolationTypeChange:
                                      onSelectedViolationTypeChange,
                                  othersController: othersController,
                                  selectedStatus: selectedStatus,
                                  selectedViolationType: selectedViolationType,
                                  violationTypeItems: violationTypeItems,
                                  violationStatusItems: violationStatusItems,
                                ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
