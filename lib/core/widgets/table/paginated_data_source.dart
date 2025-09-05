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
    originalSource.addListener(_forwardChanges);
  }

  void _forwardChanges() {
    notifyListeners();
  }

  @override
  void dispose() {
    originalSource.removeListener(_forwardChanges);
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
