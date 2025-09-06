import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../core/theme/app_colors.dart';

class CustomDataPager extends StatelessWidget {
  final DataPagerDelegate delegate;
  final int rowsPerPage;
  final int totalRows;
  final int currentPage;
  final ValueChanged<int?>? onRowsPerPageChanged;

  const CustomDataPager({
    super.key,
    required this.delegate,
    required this.rowsPerPage,
    required this.totalRows,
    required this.currentPage,
    this.onRowsPerPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final pageCount =
        totalRows > 0 ? (totalRows / rowsPerPage).ceilToDouble() : 1.0;

    final startIndex = totalRows == 0 ? 0 : (currentPage - 1) * rowsPerPage + 1;
    final endIndex =
        totalRows == 0 ? 0 : (currentPage * rowsPerPage).clamp(0, totalRows);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
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
              totalRows > 0
                  ? "Showing $startIndex to $endIndex of $totalRows entries"
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
              backgroundColor: AppColors.white,
              itemBorderRadius: BorderRadius.circular(6),
              selectedItemColor: AppColors.primary,
              itemColor: Colors.grey.shade200,
            ),
            child: SizedBox(
              width: 220,
              child: SfDataPager(
                delegate: delegate,
                pageCount: pageCount,
                onRowsPerPageChanged: onRowsPerPageChanged,
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
