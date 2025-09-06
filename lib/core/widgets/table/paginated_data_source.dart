import 'dart:math' as math;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PaginatedDataSource extends DataGridSource implements DataPagerDelegate {
  final DataGridSource originalSource;
  int totalRows;
  int rowsPerPage;
  int currentPage;

  PaginatedDataSource({
    required this.originalSource,
    required this.totalRows,
    required this.rowsPerPage,
    required this.currentPage,
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

    final end = math.min(start + rowsPerPage, all.length);

    return all.sublist(start, end);
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return originalSource.buildRow(row);
  }

  int get rowCount => originalSource.rows.length;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    currentPage = newPageIndex + 1;

    notifyListeners();
    return true;
  }
}
