import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_dimensions.dart';
import 'package:cvms_desktop/core/widgets/app/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'custom_data_pager.dart';
import 'paginated_data_source.dart';

class CustomTable extends StatefulWidget {
  final List<GridColumn> columns;
  final DataGridSource dataSource;
  final VoidCallback? onSearchCleared;
  final bool hasSearchQuery;
  final DataGridCellTapCallback? onCellTap;
  final DataGridController? controller;
  final Key? gridKey;

  const CustomTable({
    super.key,
    required this.columns,
    required this.dataSource,
    this.onSearchCleared,
    this.hasSearchQuery = false,
    this.onCellTap,
    this.controller,
    this.gridKey,
  });

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  int _rowsPerPage = 20;
  int _currentPage = 1;
  PaginatedDataSource? _paginatedSource;

  @override
  void initState() {
    super.initState();
    _createOrRefreshSource(forceRecreate: true);
  }

  @override
  void didUpdateWidget(covariant CustomTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dataSource != widget.dataSource ||
        oldWidget.columns != widget.columns) {
      _createOrRefreshSource(forceRecreate: true);
    }
  }

  void _createOrRefreshSource({bool forceRecreate = false}) {
    final totalRows = widget.dataSource.rows.length;

    if (_paginatedSource == null || forceRecreate) {
      _paginatedSource?.removeListener(_onSourceChanged);
      _paginatedSource?.dispose();

      _paginatedSource = PaginatedDataSource(
        originalSource: widget.dataSource,
        totalRows: totalRows,
        rowsPerPage: _rowsPerPage,
        currentPage: _currentPage,
      );

      _paginatedSource!.addListener(_onSourceChanged);
    } else {
      _paginatedSource!
        ..totalRows = totalRows
        ..rowsPerPage = _rowsPerPage
        ..currentPage = _currentPage
        ..notifyListeners();
    }
  }

  void _onSourceChanged() {
    if (!mounted) return;
    setState(() {
      _currentPage = _paginatedSource?.currentPage ?? 1;
    });
  }

  @override
  void dispose() {
    _paginatedSource?.removeListener(_onSourceChanged);
    _paginatedSource?.dispose();
    super.dispose();
  }

  void _handleRowsPerPageChanged(int? rows) {
    setState(() {
      _rowsPerPage = rows ?? 20;
      _currentPage = 1;
    });
    _createOrRefreshSource();
  }

  @override
  Widget build(BuildContext context) {
    final totalRows = widget.dataSource.rows.length;
    final hasData = totalRows > 0;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child:
                hasData
                    ? SfDataGridTheme(
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
                        key: widget.gridKey,
                        controller: widget.controller,
                        onCellTap: widget.onCellTap,
                        gridLinesVisibility: GridLinesVisibility.horizontal,
                        rowHeight: 36,
                        allowSorting: true,
                        headerRowHeight: AppDimensions.tableHeaderHeight,
                        source: _paginatedSource!,
                        columnWidthMode: ColumnWidthMode.fill,
                        columns: widget.columns,
                      ),
                    )
                    : EmptyState(
                      type:
                          widget.hasSearchQuery
                              ? EmptyStateType.noSearchResults
                              : EmptyStateType.noData,
                      actionText:
                          widget.hasSearchQuery &&
                                  widget.onSearchCleared != null
                              ? 'Clear Search'
                              : null,
                      onActionPressed:
                          widget.hasSearchQuery ? widget.onSearchCleared : null,
                    ),
          ),
          if (hasData)
            CustomDataPager(
              delegate: _paginatedSource!,
              rowsPerPage: _rowsPerPage,
              totalRows: totalRows,
              currentPage: _currentPage,
              onRowsPerPageChanged: _handleRowsPerPageChanged,
            ),
        ],
      ),
    );
  }
}
