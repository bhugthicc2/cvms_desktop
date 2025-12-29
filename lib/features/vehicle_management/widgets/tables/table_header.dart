import 'dart:io';

import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/utils/vehicle_csv_parser.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/buttons/custom_vehicle_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/widgets/app/search_field.dart';
import '../dialogs/custom_add_dialog.dart';

class TableHeader extends StatelessWidget {
  final TextEditingController? searchController;

  const TableHeader({super.key, this.searchController});

  // Returns a responsive width for the search field based on current screen width
  double _searchWidthFor(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 1280) {
      return 300;
    } else if (screenWidth < 1464) {
      return 400;
    }

    return 560;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (searchController != null)
              SizedBox(
                width: _searchWidthFor(context),
                height: 40,
                child: SearchField(controller: searchController!),
              ),

            Spacing.horizontal(size: AppSpacing.medium),
            Expanded(
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    //VEHICLE STATUS FILTER - Only show if at least one vehicle has logs
                    if (state.vehiclesWithLogs.isNotEmpty) ...[
                      Expanded(
                        child: CustomDropdown(
                          items: ['All', 'Onsite', 'Offsite'],
                          initialValue: 'All',
                          onChanged: (value) {
                            context.read<VehicleCubit>().filterByStatus(value);
                          },
                        ),
                      ),
                      Spacing.horizontal(size: AppSpacing.medium),
                    ],
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
                        icon: PhosphorIconsBold.package,
                        textColor:
                            state.isBulkModeEnabled
                                ? AppColors.white
                                : AppColors.black,
                        label:
                            state.isBulkModeEnabled ? "Exit Bulk" : "Bulk Mode",
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
                        icon: PhosphorIconsBold.plus,
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
                                      if (!context.mounted) return;
                                      CustomSnackBar.show(
                                        context: context,
                                        message: "Vehicle added successfully!",
                                        type: SnackBarType.success,
                                      );
                                    } catch (e) {
                                      //SHOW SNACKBAR WHEN FAIL
                                      if (!context.mounted) return;
                                      CustomSnackBar.show(
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
                    Spacing.horizontal(size: AppSpacing.medium),
                    Expanded(
                      child: CustomVehicleButton(
                        icon: PhosphorIconsBold.download,
                        label: "Import",
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['csv'],
                          );

                          if (result != null &&
                              result.files.single.path != null) {
                            final file = File(result.files.single.path!);
                            try {
                              final entries = await VehicleCsvParser.parseCsv(
                                file,
                              );
                              if (!context.mounted) return;
                              context.read<VehicleCubit>().importVehicles(
                                entries,
                              );

                              CustomSnackBar.show(
                                context: context,
                                message:
                                    "${entries.length} vehicles imported successfully!",
                                type: SnackBarType.success,
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              CustomSnackBar.show(
                                context: context,
                                message: "Import failed: $e",
                                type: SnackBarType.error,
                              );
                            }
                          }
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
