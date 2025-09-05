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

  const CustomTable({
    super.key,
    required this.columns,
    required this.dataSource,
    this.onSearchCleared,
    this.hasSearchQuery = false,
  });

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  int _rowsPerPage = 20;
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final totalRows = widget.dataSource.rows.length;
    final hasData = totalRows > 0;

    final paginatedSource = PaginatedDataSource(
      originalSource: widget.dataSource,
      totalRows: totalRows,
      rowsPerPage: _rowsPerPage,
      currentPage: _currentPage,
      onPageChanged: (page) {
        setState(() => _currentPage = page);
      },
    );

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
                        gridLinesVisibility: GridLinesVisibility.horizontal,
                        rowHeight: 36,
                        allowSorting: true,
                        headerRowHeight: AppDimensions.tableHeaderHeight,
                        source: paginatedSource,
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
              delegate: paginatedSource,
              rowsPerPage: _rowsPerPage,
              totalRows: totalRows,
              onRowsPerPageChanged: (rows) {
                setState(() {
                  _rowsPerPage = rows ?? 20;
                  _currentPage = 1;
                });
              },
              onPageChanged: (page) {
                setState(() => _currentPage = page ?? 1);
              },
            ),
        ],
      ),
    );
  }
}
