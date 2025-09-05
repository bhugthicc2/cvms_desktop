import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/dashboard/widgets/table_header.dart';
import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import '../data/vehicle_data_source.dart';
import 'vehicle_table_columns.dart';
import '../models/vehicle_entry.dart';

class VehicleTable extends StatelessWidget {
  final String title;
  final List<VehicleEntry> entries;
  final TextEditingController searchController;
  final bool hasSearchQuery;

  const VehicleTable({
    super.key,
    required this.title,
    required this.entries,
    required this.searchController,
    this.hasSearchQuery = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          TableHeader(title: title, searchController: searchController),
          Expanded(
            child: CustomTable(
              dataSource: VehicleEntryDataSource(vehicleEntries: entries),
              columns: VehicleTableColumns.columns,
              hasSearchQuery: hasSearchQuery,
              onSearchCleared: () {
                searchController.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
