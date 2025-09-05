import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/table_header.dart';
import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../data/vehicle_data_source.dart';
import 'vehicle_table_columns.dart';
import '../models/vehicle_entry.dart';

class VehicleTable extends StatelessWidget {
  final String title;
  final List<VehicleEntry> entries;
  final TextEditingController searchController;
  final DataGridCellTapCallback? onCellTap;
  const VehicleTable({
    super.key,
    required this.title,
    required this.entries,
    required this.searchController,
    this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableHeader(searchController: searchController),
        Spacing.vertical(size: AppFontSizes.medium),
        Expanded(
          child: CustomTable(
            onCellTap: onCellTap,
            dataSource: VehicleDataSource(vehicleEntries: entries),
            columns: VehicleTableColumns.columns,
            onSearchCleared: () {
              searchController.clear();
            },
          ),
        ),
      ],
    );
  }
}
