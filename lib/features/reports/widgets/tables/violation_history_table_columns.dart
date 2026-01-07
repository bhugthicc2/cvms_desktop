import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ViolationHistoryTableColumns {
  static List<GridColumn> getColumns({bool istableHeaderDark = false}) {
    return [
      TableColumnFactory.build(
        istableHeaderDark: istableHeaderDark,
        name: 'index',
        label: '#',
        width: 50,
      ),
      TableColumnFactory.build(
        istableHeaderDark: istableHeaderDark,
        name: 'violationId',
        label: 'Violation ID',
        width: 100,
      ),
      TableColumnFactory.build(
        istableHeaderDark: istableHeaderDark,
        name: 'dateTime',
        label: 'Date/Time',
      ),
      TableColumnFactory.build(
        istableHeaderDark: istableHeaderDark,
        name: 'violationType',
        label: 'Violation Type',
      ),
      TableColumnFactory.build(
        istableHeaderDark: istableHeaderDark,
        name: 'reportedBy',
        label: 'Reported By',
      ),
      TableColumnFactory.build(
        istableHeaderDark: istableHeaderDark,
        name: 'status',
        label: 'Status',
        width: 120,
      ),
      TableColumnFactory.build(
        istableHeaderDark: istableHeaderDark,
        name: 'createdAt',
        label: 'Created At',
      ),
      TableColumnFactory.build(
        istableHeaderDark: istableHeaderDark,
        name: 'lastUpdated',
        label: 'Last Updated',
      ),
    ];
  }

  // Keep the original static getter for backward compatibility
  static List<GridColumn> get columns => getColumns();
}
