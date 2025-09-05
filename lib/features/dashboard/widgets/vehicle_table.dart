import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import '../data/vehicle_data_source.dart';
import 'vehicle_table_columns.dart';
import '../models/vehicle_entry.dart';

class VehicleTable extends StatelessWidget {
  final String title;
  final List<VehicleEntry> entries;
  final TextEditingController searchController;

  const VehicleTable({
    super.key,
    required this.title,
    required this.entries,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTable(
      title: title,
      dataSource: VehicleEntryDataSource(vehicleEntries: entries),
      columns: VehicleTableColumns.columns,
      searchController: searchController,
      onSearchCleared: () {
        searchController.clear();
      },
    );
  }
}
