import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/buttons/custom_vehicle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app/search_field.dart';
import '../dialogs/custom_add_dialog.dart';

class TableHeader extends StatelessWidget {
  final TextEditingController? searchController;

  const TableHeader({super.key, this.searchController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (searchController != null)
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: SearchField(controller: searchController!),
                ),
              ),
            Spacing.horizontal(size: AppSpacing.medium),
            Expanded(
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    //VEHICLE STATUS FILTER
                    Expanded(
                      child: CustomDropdown(
                        items: ['All', 'Inside', 'Outside'],
                        initialValue: 'All',
                        onChanged: (value) {
                          context.read<VehicleCubit>().filterByStatus(value);
                        },
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    //VEHICLE TYPE FILTER
                    Expanded(
                      child: CustomDropdown(
                        items: ['All', 'two-wheeled', 'four-wheeled'],
                        initialValue: 'All',
                        onChanged: (value) {
                          context.read<VehicleCubit>().filterByType(value);
                        },
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    //TOGGLE BULK MODE BUTTON
                    Expanded(
                      child: CustomVehicleButton(
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
                          context.read<VehicleCubit>().toggleBulkMode();
                        },
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    //ADD VEHICLE BUTTON
                    Expanded(
                      child: CustomVehicleButton(
                        label: "Add Vehicle",
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder:
                                (_) => CustomAddDialog(
                                  title: "Add New Vehicle",
                                  onSave: (entry) async {
                                    try {
                                      context.read<VehicleCubit>().addVehicle(
                                        entry,
                                      );
                                      //SHOW SNACKBAR WHEN SUCCESS
                                      CustomSnackBar.show(
                                        // ignore: use_build_context_synchronously
                                        context: context,
                                        message: "Vehicle added successfully!",
                                        type: SnackBarType.success,
                                      );
                                    } catch (e) {
                                      //SHOW SNACKBAR WHEN FAIL
                                      CustomSnackBar.show(
                                        // ignore: use_build_context_synchronously
                                        context: context,
                                        message: "Failed to add vehicle: $e",
                                        type: SnackBarType.error,
                                      );
                                    }
                                  },
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
