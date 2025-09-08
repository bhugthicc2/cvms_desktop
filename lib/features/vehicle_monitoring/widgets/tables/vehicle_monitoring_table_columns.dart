import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';

class VehicleMonitoringTableColumns {
  static List<GridColumn> get columns => [
    TableColumnFactory.build(name: 'index', label: '#', width: 50),
    TableColumnFactory.build(name: 'name', label: 'Name'),
    TableColumnFactory.build(name: 'vehicle', label: 'Vehicle'),
    TableColumnFactory.build(name: 'plateNumber', label: 'Plate Number'),
    TableColumnFactory.build(name: 'duration', label: 'Duration'),
    TableColumnFactory.build(name: 'status', label: 'Status'),
  ];
}
