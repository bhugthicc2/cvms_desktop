//REFACTORED DB REFERENCE

import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_cubit.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_state.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/buttons/custom_vehiclelogs_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app/search_field.dart';

class TableHeader extends StatelessWidget {
  final TextEditingController? searchController;
  final VoidCallback? onAddVehicleLog;

  const TableHeader({super.key, this.searchController, this.onAddVehicleLog});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleLogsCubit, VehicleLogsState>(
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
                    //VEHICLE LOG STATUS FILTER
                    Expanded(
                      child: CustomDropdown(
                        backgroundColor: AppColors.white,
                        color: AppColors.black,
                        items: ['All', 'Onsite', 'Offsite'],
                        initialValue: state.statusFilter,
                        onChanged: (value) {
                          context.read<VehicleLogsCubit>().filterByStatus(
                            value,
                          );
                        },
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    //TOGGLE BULK MODE BUTTON
                    Expanded(
                      child: CustomVehicleLogsButton(
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
                          context.read<VehicleLogsCubit>().toggleBulkMode();
                        },
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    //ADD VEHICLE LOG BUTTON
                    //REFACTORED DB REFERENCE - TEMPORARILY DISABLED THE ADD LOG FUNCTIONALITY
                    Expanded(
                      child: CustomVehicleLogsButton(
                        label: "Add Log",
                        onPressed: onAddVehicleLog ?? () {},
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
