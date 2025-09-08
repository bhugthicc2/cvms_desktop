import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/tables/table_header.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/actions/toggle_actions.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/dialogs/custom_delete_dialog.dart';
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
                  //todo Handle update status
                  debugPrint(
                    'Updating status for ${state.selectedEntries.length} entries',
                  );
                },
                onReport: () {
                  //todo Handle report selected
                  debugPrint(
                    'Reporting ${state.selectedEntries.length} entries',
                  );
                },
                onDelete: () async {
                  if (state.selectedEntries.isEmpty) return;
                  
                  final vehicleCubit = context.read<VehicleCubit>();
                  showDialog(
                    context: context,
                    builder: (dialogContext) => CustomDeleteDialog(
                      title: 'Delete Vehicles',
                      selectedCount: state.selectedEntries.length,
                      onDelete: () async {
                        try {
                          await vehicleCubit.bulkDeleteVehicles();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Successfully deleted ${state.selectedEntries.length} vehicle(s)',
                                  style: const TextStyle(fontFamily: 'Sora'),
                                ),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Failed to delete vehicles: ${e.toString()}',
                                  style: const TextStyle(fontFamily: 'Sora'),
                                ),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
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
