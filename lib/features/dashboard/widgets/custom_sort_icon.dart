import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../core/theme/app_colors.dart';

class CustomSortIcon extends StatelessWidget {
  final DataGridSortDirection? sortDirection;

  const CustomSortIcon({super.key, this.sortDirection});

  @override
  Widget build(BuildContext context) {
    final isAscending = sortDirection == DataGridSortDirection.ascending;
    final isDescending = sortDirection == DataGridSortDirection.descending;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          PhosphorIconsFill.caretUp,
          size: 12,
          color: isAscending ? AppColors.white : AppColors.grey,
        ),
        Icon(
          PhosphorIconsFill.caretDown,
          size: 12,
          color: isDescending ? AppColors.white : AppColors.grey,
        ),
      ],
    );
  }
}
