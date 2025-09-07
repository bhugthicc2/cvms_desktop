import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/custom_vehicle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/app/search_field.dart';
import 'custom_form_dialog.dart';

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
                    Expanded(
                      child: CustomDropdown(
                        items: ['All', 'Two-wheeled', 'Four-wheeled'],
                        initialValue: 'All',
                        onChanged: (value) {
                          context.read<VehicleCubit>().filterByType(value);
                        },
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    Expanded(
                      child: CustomVehicleButton(
                        label:
                            state.isBulkModeEnabled
                                ? "Exit Bulk Mode"
                                : "Bulk Mode",
                        backgroundColor:
                            state.isBulkModeEnabled
                                ? AppColors.warning
                                : AppColors.primary,
                        onPressed: () {
                          context.read<VehicleCubit>().toggleBulkMode();
                        },
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    Expanded(
                      child: CustomVehicleButton(
                        label: "Add Vehicle",
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (_) => const CustomFormDialog(
                                  title: "Add New Vehicle",
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
