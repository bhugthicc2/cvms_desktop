import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/tables/table_header.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/actions/toggle_actions.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/dialogs/custom_delete_dialog.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/dialogs/custom_report_dialog.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/dialogs/custom_update_status_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import '../../data/vehicle_data_source.dart';
import 'vehicle_table_columns.dart';
import '../../models/vehicle_entry.dart';
import '../../bloc/vehicle_cubit.dart';

class VehicleTable extends StatelessWidget {
  final String title;
  final List<VehicleEntry> entries;
  final TextEditingController searchController;

  const VehicleTable({
    super.key,
    required this.title,
    required this.entries,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        return Column(
          children: [
            TableHeader(searchController: searchController),
            if (state.isBulkModeEnabled) ...[
              Spacing.vertical(size: AppFontSizes.medium),
              ToggleActions(
                exportValue: state.selectedEntries.length.toString(),
                reportValue: state.selectedEntries.length.toString(),
                deleteValue: state.selectedEntries.length.toString(),
                updateValue: state.selectedEntries.length.toString(),
                onExport: () {
                  //todo Handle export QR codes
                  debugPrint(
                    'Exporting QR codes for ${state.selectedEntries.length} entries',
                  );
                },
                onUpdate: () {
                  if (state.selectedEntries.isEmpty) return;

                  final vehicleCubit = context.read<VehicleCubit>();
                  showDialog(
                    context: context,
                    builder: (dialogContext) => CustomUpdateStatusDialog(
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
                    builder: (dialogContext) => BlocProvider.value(
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
              child: CustomTable(
                dataSource: VehicleDataSource(
                  vehicleEntries: entries,
                  showCheckbox: state.isBulkModeEnabled,
                  context: context,
                ),
                columns: VehicleTableColumns.getColumns(
                  showCheckbox: state.isBulkModeEnabled,
                ),
                onSearchCleared: () {
                  searchController.clear();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
