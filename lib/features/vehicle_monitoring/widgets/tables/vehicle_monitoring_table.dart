import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/widgets/tables/vehicle_monitoring_table_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../data/vehicle_monitoring_data_source.dart';
import 'vehicle_monitoring_table_columns.dart';
import '../../models/vehicle_monitoring_entry.dart';

class VehicleMonitoringTable extends StatefulWidget {
  final String title;
  final List<VehicleMonitoringEntry> entries;
  final TextEditingController searchController;
  final bool hasSearchQuery;
  final DataGridCellTapCallback? onCellTap;
  final Function(VehicleMonitoringEntry, int)? onActionTap;

  const VehicleMonitoringTable({
    super.key,
    required this.title,
    required this.entries,
    required this.searchController,
    this.hasSearchQuery = false,
    this.onCellTap,
    this.onActionTap,
  });

  @override
  State<VehicleMonitoringTable> createState() => _VehicleMonitoringTableState();
}

class _VehicleMonitoringTableState extends State<VehicleMonitoringTable> {
  late VehicleMonitoringDataSource _dataSource;
  final DataGridController _controller = DataGridController();

  @override
  void initState() {
    super.initState();
    _dataSource = VehicleMonitoringDataSource(vehicleEntries: widget.entries);
  }

  @override
  void didUpdateWidget(covariant VehicleMonitoringTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.entries, widget.entries) ||
        oldWidget.onActionTap != widget.onActionTap) {
      _dataSource = VehicleMonitoringDataSource(vehicleEntries: widget.entries);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          VehicleMonitoringTableHeader(
            title: widget.title,
            searchController: widget.searchController,
          ),
          Expanded(
            child: CustomTable(
              gridKey: ValueKey('vehicleMonitoringGrid-${widget.title}'),
              controller: _controller,
              onCellTap: widget.onCellTap,
              dataSource: _dataSource,
              columns: VehicleMonitoringTableColumns.columns,
              hasSearchQuery: widget.hasSearchQuery,
              onSearchCleared: () {
                widget.searchController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
