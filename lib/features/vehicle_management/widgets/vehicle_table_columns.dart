import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cvms_desktop/core/widgets/table/table_column_factory.dart';

class VehicleTableColumns {
  static List<GridColumn> get columns => [
    TableColumnFactory.build(name: 'index', label: '#', width: 50),
    TableColumnFactory.build(name: 'name', label: 'Name'),
    TableColumnFactory.build(name: 'vehicle', label: 'Vehicle'),
    TableColumnFactory.build(name: 'SchoolID', label: 'School ID'),
    TableColumnFactory.build(name: 'plateNumber', label: 'Plate Number'),
    TableColumnFactory.build(name: 'vehicleModel', label: 'Vehicle Model'),
    TableColumnFactory.build(name: 'vehicleType', label: 'Vehicle Type'),
    TableColumnFactory.build(name: 'vehicleColor', label: 'Vehicle Color'),
    TableColumnFactory.build(name: 'status', label: 'Status'),
    TableColumnFactory.build(
      name: 'violationStatus',
      label: 'Violation Status',
    ),
    TableColumnFactory.build(name: 'actions', label: 'Actions'),
  ];
}
