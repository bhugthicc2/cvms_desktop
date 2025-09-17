import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_cubit.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_state.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/buttons/custom_vehiclelogs_button.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/dialogs/custom_add_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app/search_field.dart';

class TableHeader extends StatelessWidget {
  final TextEditingController? searchController;

  const TableHeader({super.key, this.searchController});

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
                        items: ['Vehicle Status', 'Inside', 'Outside'],
                        initialValue: 'Vehicle Status',
                        onChanged: (value) {
                          //TODO
                        },
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    //VEHICLE LOG TYPE FILTER
                    Expanded(
                      child: CustomDropdown(
                        backgroundColor: AppColors.white,
                        color: AppColors.black,
                        items: ['Vehicle Type', 'two-wheeled', 'four-wheeled'],
                        initialValue: 'Vehicle Type',
                        onChanged: (value) {
                          //TODO
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
                    Expanded(
                      child: CustomVehicleLogsButton(
                        label: "Add Log",
                        onPressed: () {
                          final cubit = context.read<VehicleLogsCubit>();
                          showDialog(
                            context: context,
                            builder:
                                (dialogContext) => BlocProvider.value(
                                  value: cubit,
                                  child: BlocListener<
                                    VehicleLogsCubit,
                                    VehicleLogsState
                                  >(
                                    listener: (context, state) {
                                      if (state.error != null) {
                                        Navigator.of(dialogContext).pop();
                                        CustomSnackBar.show(
                                          context: context,
                                          message: state.error!,
                                          type: SnackBarType.error,
                                        );
                                      }
                                    },
                                    child: CustomAddDialog(
                                      title: "Add New Vehicle Log",
                                      onSave: (entry) async {
                                        try {
                                          await cubit.addManualLog(entry);

                                          // Close dialog first
                                          if (dialogContext.mounted) {
                                            Navigator.of(dialogContext).pop();
                                          }

                                          // Then show success message
                                          if (context.mounted) {
                                            CustomSnackBar.show(
                                              context: context,
                                              message:
                                                  "Vehicle log saved successfully!",
                                              type: SnackBarType.success,
                                            );
                                          }
                                        } catch (e) {
                                          // Error handling is done by BlocListener
                                        }
                                      },
                                    ),
                                  ),
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
