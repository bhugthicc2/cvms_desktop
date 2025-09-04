import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../core/theme/app_colors.dart';

class CustomDataPager extends StatelessWidget {
  final DataPagerDelegate delegate;
  final int rowsPerPage;
  final int totalRows;
  final ValueChanged<int?>? onRowsPerPageChanged;

  const CustomDataPager({
    super.key,
    required this.delegate,
    required this.rowsPerPage,
    required this.totalRows,
    this.onRowsPerPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final pageCount =
        totalRows > 0 ? (totalRows / rowsPerPage).ceilToDouble() : 1.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              totalRows > 0
                  ? "Showing 1 to ${totalRows < rowsPerPage ? totalRows : rowsPerPage} of $totalRows entries"
                  : "Showing 0 of 0 entries",
              style: const TextStyle(
                fontSize: AppFontSizes.xMedium,
                color: AppColors.grey,
              ),
            ),
          ),
        ),
        const Spacer(),
        SfDataPagerTheme(
          data: SfDataPagerThemeData(
            backgroundColor: Colors.white,
            itemBorderRadius: BorderRadius.circular(6),
            selectedItemColor: AppColors.primary,
            itemColor: Colors.grey.shade200,
            selectedItemTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            itemTextStyle: const TextStyle(
              color: AppColors.black,
              fontSize: AppFontSizes.small,
            ),
          ),
          child: SizedBox(
            width: 220,
            child: SfDataPagerTheme(
              data: SfDataPagerThemeData(
                backgroundColor: Colors.transparent,
                itemBorderRadius: BorderRadius.circular(3),
                selectedItemColor: AppColors.primary,
                selectedItemTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                itemTextStyle: const TextStyle(
                  fontSize: AppFontSizes.medium,
                  color: Colors.black,
                ),
              ),
              child: SfDataPager(
                delegate: delegate,
                pageCount: pageCount,
                onRowsPerPageChanged: null,
                itemWidth: 40,
                itemHeight: 36,
                firstPageItemVisible: false,
                lastPageItemVisible: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
