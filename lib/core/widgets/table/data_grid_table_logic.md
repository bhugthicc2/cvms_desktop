###CUSTOM DATA PAGER

import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../core/theme/app_colors.dart';

class CustomDataPager extends StatefulWidget {
final DataPagerDelegate delegate;
final int rowsPerPage;
final int totalRows;
final ValueChanged<int?>? onRowsPerPageChanged;
final ValueChanged<int?>? onPageChanged;

const CustomDataPager({
super.key,
required this.delegate,
required this.rowsPerPage,
required this.totalRows,
this.onRowsPerPageChanged,
this.onPageChanged,
});

@override
State<CustomDataPager> createState() => \_CustomDataPagerState();
}

class \_CustomDataPagerState extends State<CustomDataPager> {
int \_currentPage = 1;

@override
Widget build(BuildContext context) {
final pageCount =
widget.totalRows > 0
? (widget.totalRows / widget.rowsPerPage).ceilToDouble()
: 1.0;

    final startIndex = (_currentPage - 1) * widget.rowsPerPage + 1;
    final endIndex = (_currentPage * widget.rowsPerPage).clamp(
      0,
      widget.totalRows,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: Text(
              widget.totalRows > 0
                  ? "Showing $startIndex to $endIndex of ${widget.totalRows} entries"
                  : "Showing 0 of 0 entries",
              style: const TextStyle(
                fontSize: AppFontSizes.xMedium,
                color: AppColors.grey,
              ),
            ),
          ),
          const Spacer(),
          SfDataPagerTheme(
            data: SfDataPagerThemeData(
              backgroundColor: Colors.white,
              itemBorderRadius: BorderRadius.circular(6),
              selectedItemColor: AppColors.primary,
              itemColor: Colors.grey.shade200,
            ),
            child: SizedBox(
              width: 220,
              child: SfDataPager(
                delegate: widget.delegate,
                pageCount: pageCount,
                onRowsPerPageChanged: widget.onRowsPerPageChanged,
                onPageNavigationStart: (pageIndex) {
                  setState(() => _currentPage = pageIndex + 1);
                  widget.onPageChanged?.call(_currentPage);
                },
                itemWidth: 40,
                itemHeight: 36,
                firstPageItemVisible: false,
                lastPageItemVisible: false,
              ),
            ),
          ),
        ],
      ),
    );

}
}

###CUSTOM TABLE

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
State<CustomTable> createState() => \_CustomTableState();
}

class \_CustomTableState extends State<CustomTable> {
int \_rowsPerPage = 20;
int \_currentPage = 1;
PaginatedDataSource? \_paginatedSource;

@override
void initState() {
super.initState();
\_rebuildPaginatedSource();
}

@override
void didUpdateWidget(covariant CustomTable oldWidget) {
super.didUpdateWidget(oldWidget);
if (oldWidget.dataSource != widget.dataSource ||
oldWidget.columns != widget.columns ||
\_paginatedSource == null) {
\_rebuildPaginatedSource();
}
}

void _rebuildPaginatedSource() {
final oldSource = \_paginatedSource;
final totalRows = widget.dataSource.rows.length;
\_paginatedSource = PaginatedDataSource(
originalSource: widget.dataSource,
totalRows: totalRows,
rowsPerPage: \_rowsPerPage,
currentPage: \_currentPage,
onPageChanged: (page) {
setState(() => \_currentPage = page);
},
);
if (oldSource != null) {
WidgetsBinding.instance.addPostFrameCallback((_) {
oldSource.dispose();
});
}
}

@override
void dispose() {
\_paginatedSource?.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
final totalRows = widget.dataSource.rows.length;
final hasData = totalRows > 0;
// ensure data pager reflects latest totals
if (\_paginatedSource == null) {
\_rebuildPaginatedSource();
}

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
              onRowsPerPageChanged: (rows) {
                setState(() {
                  _rowsPerPage = rows ?? 20;
                  _currentPage = 1;
                  _rebuildPaginatedSource();
                });
              },
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page ?? 1;
                  _rebuildPaginatedSource();
                });
              },
            ),
        ],
      ),
    );

}
}

###PAGINATED DATA SOURCE

import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PaginatedDataSource extends DataGridSource implements DataPagerDelegate {
final DataGridSource originalSource;
final int totalRows;
final int rowsPerPage;
final int currentPage;
final ValueChanged<int>? onPageChanged;

PaginatedDataSource({
required this.originalSource,
required this.totalRows,
required this.rowsPerPage,
required this.currentPage,
this.onPageChanged,
}) {
originalSource.addListener(\_forwardChanges);
}

void \_forwardChanges() {
notifyListeners();
}

@override
void dispose() {
originalSource.removeListener(\_forwardChanges);
super.dispose();
}

@override
List<DataGridRow> get rows {
final all = originalSource.rows;
if (all.isEmpty) return const [];

    final start = (currentPage - 1) * rowsPerPage;

    if (start >= all.length) return const [];

    final end = (start + rowsPerPage).clamp(0, all.length);
    return all.sublist(start, end);

}

@override
DataGridRowAdapter? buildRow(DataGridRow row) {
return originalSource.buildRow(row);
}

int get rowCount => totalRows;

@override
Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
onPageChanged?.call(newPageIndex + 1);
return true;
}
}
