import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/tables/table_header.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/actions/toggle_actions.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/dialogs/custom_delete_dialog.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/dialogs/custom_report_dialog.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/dialogs/custom_update_status_dialog.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/tables/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import '../datasource/vehicle_data_source.dart';
import 'vehicle_table_columns.dart';
import '../../models/vehicle_entry.dart';
import '../../bloc/vehicle_cubit.dart';

class VehicleTable extends StatelessWidget {
  final String title;
  final List<VehicleEntry> entries;
  final TextEditingController searchController;
  final VoidCallback onAddVehicle;
  final bool hasImportBtn;
  final Widget? additionalHeaderItem;
  const VehicleTable({
    super.key,
    required this.title,
    required this.entries,
    required this.searchController,
    required this.onAddVehicle,
    this.hasImportBtn = true,
    this.additionalHeaderItem,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VehicleCubit, VehicleState>(
      listenWhen:
          (previous, current) =>
              previous.isExporting != current.isExporting ||
              previous.exportedFilePath != current.exportedFilePath ||
              previous.error != current.error,
      listener: (context, state) {
        // Show success when a directory/file path is returned
        if (state.exportedFilePath != null) {
          CustomSnackBar.show(
            context: context,
            message:
                'Export complete. Files saved to: ${state.exportedFilePath}',
            type: SnackBarType.success,
          );
          return;
        }

        // Show error if any
        if (state.error != null) {
          CustomSnackBar.show(
            context: context,
            message: state.error!,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            TopBar(
              metrics: TopBarMetrics(
                totalVehicles: state.allEntries.length,
                onsiteVehicles:
                    state.allEntries.where((v) => v.status == 'onsite').length,
                registeredVehicles:
                    state.allEntries
                        .where((v) => v.status == 'registered')
                        .length, //todo registered status means registered vehicles
                twoWheeled:
                    state.allEntries
                        .where((v) => v.vehicleType == 'two-wheeled')
                        .length,
                fourWheeled:
                    state.allEntries
                        .where((v) => v.vehicleType == 'four-wheeled')
                        .length,
              ),
            ), //this shows the stats or summary of the vehicles
            //todo summary here.......................
            Spacing.vertical(size: AppFontSizes.medium),
            TableHeader(
              hasImportBtn: hasImportBtn,
              searchController: searchController,
              onAddVehicle: onAddVehicle,
              additionalWidget: additionalHeaderItem,
            ),
            if (state.isBulkModeEnabled) ...[
              Spacing.vertical(size: AppFontSizes.medium),
              ToggleActions(
                exportValue: state.selectedEntries.length.toString(),
                reportValue: state.selectedEntries.length.toString(),
                deleteValue: state.selectedEntries.length.toString(),
                updateValue: state.selectedEntries.length.toString(),
                onExport: () {
                  // Immediate user feedback
                  CustomSnackBar.show(
                    context: context,
                    message:
                        'Starting export for ${state.selectedEntries.length} vehicle(s). You will be asked to choose a folder.',
                    type: SnackBarType.info,
                  );
                  context.read<VehicleCubit>().bulkExportAsPng();
                },

                onUpdate: () {
                  if (state.selectedEntries.isEmpty) return;

                  final vehicleCubit = context.read<VehicleCubit>();
                  showDialog(
                    context: context,
                    builder:
                        (dialogContext) => CustomUpdateStatusDialog(
                          selectedCount: state.selectedEntries.length,
                          onSave: (newStatus) async {
                            try {
                              await vehicleCubit.bulkUpdateStatus(newStatus);
                              if (context.mounted) {
                                CustomSnackBar.show(
                                  context: context,
                                  message:
                                      'Successfully updated status for ${state.selectedEntries.length} vehicle(s)',
                                  type: SnackBarType.success,
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                CustomSnackBar.show(
                                  context: context,
                                  message:
                                      'Failed to update status: ${e.toString()}',
                                  type: SnackBarType.error,
                                );
                              }
                            }
                          },
                        ),
                  );
                },
                onReport: () {
                  if (state.selectedEntries.isEmpty) return;

                  final vehicleCubit = context.read<VehicleCubit>();
                  showDialog(
                    context: context,
                    builder:
                        (dialogContext) => BlocProvider.value(
                          value: vehicleCubit,
                          child: CustomReportDialog(
                            title: 'Report Violations',
                            selectedCount: state.selectedEntries.length,
                          ),
                        ),
                  );
                },
                onDelete: () async {
                  if (state.selectedEntries.isEmpty) return;

                  final vehicleCubit = context.read<VehicleCubit>();
                  showDialog(
                    context: context,
                    builder:
                        (dialogContext) => CustomDeleteDialog(
                          title: 'Delete Vehicles',
                          selectedCount: state.selectedEntries.length,
                          onDelete: () async {
                            try {
                              await vehicleCubit.bulkDeleteVehicles();
                              if (context.mounted) {
                                CustomSnackBar.show(
                                  context: context,
                                  message:
                                      'Successfully deleted ${state.selectedEntries.length} vehicle(s)',
                                  type: SnackBarType.success,
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                CustomSnackBar.show(
                                  context: context,
                                  message:
                                      'Failed to delete vehicles: ${e.toString()}',
                                  type: SnackBarType.error,
                                );
                              }
                            }
                          },
                        ),
                  );
                },
              ),
            ],
            Spacing.vertical(size: AppFontSizes.medium),
            Expanded(
              child: Builder(
                builder: (context) {
                  // Show status column if at least one vehicle in the system has logs
                  // Individual cells will show empty for vehicles without logs
                  final showStatus = state.vehiclesWithLogs.isNotEmpty;

                  return CustomTable(
                    dataSource: VehicleDataSource(
                      vehicleEntries: entries,
                      showCheckbox: state.isBulkModeEnabled,
                      showStatus: showStatus,
                      context: context,
                    ),
                    columns: VehicleTableColumns.getColumns(
                      showCheckbox: state.isBulkModeEnabled,
                      showStatus: showStatus,
                    ),
                    onSearchCleared: () {
                      searchController.clear();
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
