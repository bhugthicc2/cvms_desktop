import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/dashboard/widgets/table_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../data/vehicle_data_source.dart';
import 'vehicle_table_columns.dart';
import '../models/vehicle_entry.dart';

class VehicleTable extends StatefulWidget {
  final String title;
  final List<VehicleEntry> entries;
  final TextEditingController searchController;
  final bool hasSearchQuery;
  final DataGridCellTapCallback? onCellTap;
  final Function(VehicleEntry, int)? onActionTap;

  const VehicleTable({
    super.key,
    required this.title,
    required this.entries,
    required this.searchController,
    this.hasSearchQuery = false,
    this.onCellTap,
    this.onActionTap,
  });
  @override
  State<VehicleTable> createState() => _VehicleTableState();
}

class _VehicleTableState extends State<VehicleTable> {
  late VehicleEntryDataSource _dataSource;
  final DataGridController _controller = DataGridController();

  @override
  void initState() {
    super.initState();
    _dataSource = VehicleEntryDataSource(
      vehicleEntries: widget.entries,
      onActionTap: widget.onActionTap,
      context: context,
    );
  }

  @override
  void didUpdateWidget(covariant VehicleTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.entries, widget.entries) ||
        oldWidget.onActionTap != widget.onActionTap) {
      _dataSource = VehicleEntryDataSource(
        vehicleEntries: widget.entries,
        onActionTap: widget.onActionTap,
        context: context,
      );
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
          TableHeader(
            title: widget.title,
            searchController: widget.searchController,
          ),
          Expanded(
            child: CustomTable(
              gridKey: ValueKey('vehicleGrid-${widget.title}'),
              controller: _controller,
              onCellTap: widget.onCellTap,
              dataSource: _dataSource,
              columns: VehicleTableColumns.columns,
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
