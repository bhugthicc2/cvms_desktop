import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';

class TableColumnFactory {
  static GridColumn build({
    required String name,
    required String label,
    double? width,
    Alignment alignment = Alignment.center,
  }) {
    return GridColumn(
      columnName: name,
      filterIconPadding: const EdgeInsets.all(8),
      width: width ?? double.nan,
      label: Container(
        alignment: alignment,
        padding: const EdgeInsets.all(8),
        color: AppColors.tableHeaderColor,
        child: Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          label,
          style: const TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
            fontSize: AppFontSizes.small,
            color: AppColors.white,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
