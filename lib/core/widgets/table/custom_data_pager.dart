import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../core/theme/app_colors.dart';

class CustomDataPager extends StatefulWidget {
  final DataPagerDelegate delegate;
  final int rowsPerPage;
  final int totalRows;
  final ValueChanged<int?>? onRowsPerPageChanged;
  final ValueChanged<int?>? onPageChanged;

  const CustomDataPager({
    super.key,
    required this.delegate,
    required this.rowsPerPage,
    required this.totalRows,
    this.onRowsPerPageChanged,
    this.onPageChanged,
  });

  @override
  State<CustomDataPager> createState() => _CustomDataPagerState();
}

class _CustomDataPagerState extends State<CustomDataPager> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final pageCount =
        widget.totalRows > 0
            ? (widget.totalRows / widget.rowsPerPage).ceilToDouble()
            : 1.0;

    final startIndex = (_currentPage - 1) * widget.rowsPerPage + 1;
    final endIndex = (_currentPage * widget.rowsPerPage).clamp(
      0,
      widget.totalRows,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
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
              widget.totalRows > 0
                  ? "Showing $startIndex to $endIndex of ${widget.totalRows} entries"
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
              backgroundColor: Colors.white,
              itemBorderRadius: BorderRadius.circular(6),
              selectedItemColor: AppColors.primary,
              itemColor: Colors.grey.shade200,
            ),
            child: SizedBox(
              width: 220,
              child: SfDataPager(
                delegate: widget.delegate,
                pageCount: pageCount,
                onRowsPerPageChanged: widget.onRowsPerPageChanged,
                onPageNavigationStart: (pageIndex) {
                  setState(() => _currentPage = pageIndex + 1);
                  widget.onPageChanged?.call(_currentPage);
                },
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
