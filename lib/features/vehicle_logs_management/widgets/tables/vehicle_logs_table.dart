import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/actions/toggle_actions.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/dialogs/custom_delete_dialog.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/tables/table_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../datasource/vehicle_logs_data_source.dart';
import 'vehicle_logs_table_columns.dart';
import '../../models/vehicle_log_model.dart';
import '../../bloc/vehicle_logs_cubit.dart';
import '../../bloc/vehicle_logs_state.dart';

class VehicleLogsTable extends StatefulWidget {
  final String title;
  final List<VehicleLogModel> logs;
  final TextEditingController searchController;
  final bool hasSearchQuery;
  final DataGridCellTapCallback? onCellTap;
  final Function(VehicleLogModel, int)? onActionTap;

  const VehicleLogsTable({
    super.key,
    required this.title,
    required this.logs,
    required this.searchController,
    this.hasSearchQuery = false,
    this.onCellTap,
    this.onActionTap,
  });

  @override
  State<VehicleLogsTable> createState() => _VehicleLogsManagementState();
}

class _VehicleLogsManagementState extends State<VehicleLogsTable> {
  late VehicleLogsDataSource _dataSource;
  final DataGridController _controller = DataGridController();

  @override
  void initState() {
    super.initState();
    _dataSource = VehicleLogsDataSource(
      vehicleLogEntries: widget.logs,
      showCheckbox: false, // Will be updated in didUpdateWidget
    );
  }

  @override
  void didUpdateWidget(covariant VehicleLogsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.logs, widget.logs) ||
        oldWidget.onActionTap != widget.onActionTap) {
      _dataSource = VehicleLogsDataSource(
        vehicleLogEntries: widget.logs,
        showCheckbox: false, // Will be updated in build method
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleLogsCubit, VehicleLogsState>(
      builder: (context, state) {
        // Update data source when bulk mode changes
        _dataSource = VehicleLogsDataSource(
          vehicleLogEntries: widget.logs,
          showCheckbox: state.isBulkModeEnabled,
        );

        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              TableHeader(searchController: widget.searchController),
              if (state.isBulkModeEnabled) ...[
                Spacing.vertical(size: AppFontSizes.medium),
                ToggleActions(
                  reportValue: state.selectedEntries.length.toString(),
                  deleteValue: state.selectedEntries.length.toString(),
                  updateValue: state.selectedEntries.length.toString(),
                  onExport: () {
                    context.read<VehicleLogsCubit>().bulkExportLogs();
                  },
                  onUpdate: () {
                    _showUpdateStatusDialog(context);
                  },
                  onReport: () {
                    _showReportViolationsDialog(context);
                  },
                  onDelete: () async {
                    _showDeleteConfirmationDialog(context);
                  },
                ),
              ],
              Spacing.vertical(size: AppFontSizes.medium),
              Expanded(
                child: CustomTable(
                  gridKey: ValueKey('vehicleLogsGrid-${widget.title}'),
                  controller: _controller,
                  onCellTap: widget.onCellTap,
                  dataSource: _dataSource,
                  columns: VehicleLogsTableColumns.getColumns(
                    showCheckbox: state.isBulkModeEnabled,
                  ),
                  hasSearchQuery: widget.hasSearchQuery,
                  onSearchCleared: () {
                    widget.searchController.clear();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUpdateStatusDialog(BuildContext context) {
    //todo
  }

  void _showReportViolationsDialog(BuildContext context) {
    //todo
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    //todo
    showDialog(
      context: context,
      builder:
          (_) => CustomDeleteDialog(
            title: "Delete Vehicle",
            message: "Are you sure you want to delete these selected vehicles?",
            onConfirm: () {
              //todo
            },
          ),
    );
  }
}
