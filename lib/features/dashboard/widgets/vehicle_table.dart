import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_dimensions.dart';
import 'package:cvms_desktop/features/dashboard/data/vehicle_data_source.dart';
import 'package:cvms_desktop/features/dashboard/widgets/custom_data_pager.dart';
import 'package:cvms_desktop/features/dashboard/widgets/empty_state.dart';
import 'package:cvms_desktop/features/dashboard/widgets/vehicle_table_columns.dart';
import 'package:cvms_desktop/features/dashboard/widgets/vehicle_table_header.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../models/vehicle_entry.dart';

class VehicleTable extends StatefulWidget {
  final String title;
  final List<VehicleEntry> entries;

  const VehicleTable({super.key, required this.title, required this.entries});

  @override
  State<VehicleTable> createState() => _VehicleTableState();
}

class _VehicleTableState extends State<VehicleTable> {
  int _rowsPerPage = 20;
  late VehicleEntryDataSource _dataSource;
  final TextEditingController _searchController = TextEditingController();
  List<VehicleEntry> _filteredEntries = [];

  @override
  void initState() {
    super.initState();
    _filteredEntries = widget.entries;
    _dataSource = VehicleEntryDataSource(vehicleEntries: _filteredEntries);
    _searchController.addListener(_filterEntries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterEntries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredEntries = widget.entries;
      } else {
        _filteredEntries =
            widget.entries.where((entry) {
              return entry.name.toLowerCase().contains(query) ||
                  entry.vehicle.toLowerCase().contains(query) ||
                  entry.plateNumber.toLowerCase().contains(query);
            }).toList();
      }
      _dataSource = VehicleEntryDataSource(vehicleEntries: _filteredEntries);
    });
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
          VehicleTableHeader(
            searchController: _searchController,
            title: widget.title,
          ),
          Expanded(
            child:
                _filteredEntries.isEmpty
                    ? _buildEmptyState()
                    : SfDataGridTheme(
                      data: SfDataGridThemeData(
                        headerColor: AppColors.tableHeaderColor,
                        gridLineStrokeWidth: 0,
                        sortIcon: Icon(
                          PhosphorIconsFill.caretDown,
                          color: AppColors.white,
                          size: 11,
                        ),
                      ),
                      child: SfDataGrid(
                        gridLinesVisibility: GridLinesVisibility.horizontal,
                        rowHeight: 36,
                        allowSorting: true,
                        headerRowHeight: AppDimensions.tableHeaderHeight,
                        source: _dataSource,
                        columnWidthMode: ColumnWidthMode.fill,
                        columns: VehicleTableColumns.columns,
                      ),
                    ),
          ),
          if (_filteredEntries.isNotEmpty)
            CustomDataPager(
              delegate: _dataSource,
              rowsPerPage: _rowsPerPage,
              totalRows: _filteredEntries.length,
              onRowsPerPageChanged: (rowsPerPage) {
                setState(() {
                  _rowsPerPage = rowsPerPage ?? 20;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasSearchQuery = _searchController.text.isNotEmpty;
    final hasOriginalData = widget.entries.isNotEmpty;

    EmptyStateType emptyStateType;
    String? actionText;
    VoidCallback? onActionPressed;

    if (hasSearchQuery) {
      emptyStateType = EmptyStateType.noSearchResults;
      actionText = 'Clear Search';
      onActionPressed = () {
        _searchController.clear();
      };
    } else if (hasOriginalData) {
      emptyStateType = EmptyStateType.noData;
    } else {
      if (widget.title.toLowerCase().contains('entered')) {
        emptyStateType = EmptyStateType.noData;
      } else if (widget.title.toLowerCase().contains('exited')) {
        emptyStateType = EmptyStateType.noData;
      } else {
        emptyStateType = EmptyStateType.noVehicles;
      }
    }

    return EmptyState(
      type: emptyStateType,
      actionText: actionText,
      onActionPressed: onActionPressed,
    );
  }
}
