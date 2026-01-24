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
  final List<int> availableRowsPerPage;

  const CustomDataPager({
    super.key,
    required this.delegate,
    required this.rowsPerPage,
    required this.totalRows,
    required this.currentPage,
    this.onRowsPerPageChanged,
    this.availableRowsPerPage = const [10, 25, 50, 100],
  });

  @override
  Widget build(BuildContext context) {
    final pageCount =
        totalRows > 0 ? (totalRows / rowsPerPage).ceilToDouble() : 1.0;

    final startIndex = totalRows == 0 ? 0 : (currentPage - 1) * rowsPerPage + 1;
    final endIndex =
        totalRows == 0 ? 0 : (currentPage * rowsPerPage).clamp(0, totalRows);

    return Container(
      height: 45,
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
          // Rows per page dropdown
          if (onRowsPerPageChanged != null) ...[
            const SizedBox(width: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rows per page:',
                  style: const TextStyle(
                    fontSize: AppFontSizes.xMedium,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: rowsPerPage,
                      items:
                          availableRowsPerPage.map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(
                                value.toString(),
                                style: const TextStyle(
                                  fontSize: AppFontSizes.xMedium,
                                  color: AppColors.grey,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: onRowsPerPageChanged,
                      isDense: true,
                      iconSize: 20,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const Spacer(),
          SfDataPagerTheme(
            data: SfDataPagerThemeData(
              backgroundColor: AppColors.white,
              itemBorderRadius: BorderRadius.circular(5),
              selectedItemColor: AppColors.primary,
              itemColor: Colors.grey.shade200,
            ),
            child: SizedBox(
              width: 220,
              child: Align(
                alignment: Alignment.centerRight,
                child: SfDataPager(
                  delegate: delegate,
                  pageCount: pageCount,
                  onRowsPerPageChanged: onRowsPerPageChanged,
                  itemWidth: 40,
                  itemHeight: 36,
                  firstPageItemVisible: false,
                  navigationItemHeight: 40,
                  navigationItemWidth: 40,

                  lastPageItemVisible: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
