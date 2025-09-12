import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/actions/toggle_actions.dart';
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
    _dataSource = VehicleLogsDataSource(vehicleLogEntries: widget.logs);
  }

  @override
  void didUpdateWidget(covariant VehicleLogsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.logs, widget.logs) ||
        oldWidget.onActionTap != widget.onActionTap) {
      _dataSource = VehicleLogsDataSource(vehicleLogEntries: widget.logs);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleLogsCubit, VehicleLogsState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              TableHeader(searchController: widget.searchController),
              if (state.isBulkModeEnabled) ...[
                Spacing.vertical(size: AppFontSizes.medium),
                ToggleActions(
                  exportValue: '', //todo
                  reportValue: '', //todo
                  deleteValue: '', //todo
                  updateValue: '', //todo
                  onExport: () {
                    //todo
                  },
                  onUpdate: () {
                    //todo
                  },
                  onReport: () {
                    //todo
                  },
                  onDelete: () async {
                    //todo
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
                  columns: VehicleLogsTableColumns.columns,
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
}
