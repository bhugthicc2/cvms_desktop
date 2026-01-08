import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';

class TableColumnFactory {
  static GridColumn build({
    required String name,
    required String label,
    bool istableHeaderDark = true,
    double? width,
    Alignment alignment = Alignment.center,
  }) {
    return GridColumn(
      columnName: name,
      filterIconPadding: const EdgeInsets.all(8),
      width: width ?? double.nan,
      label: HoverGrow(
        child: Container(
          alignment: alignment,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                istableHeaderDark
                    ? AppColors.tableHeaderColor
                    : AppColors.greySurface,
          ),
          child: Text(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
              color: istableHeaderDark ? AppColors.white : AppColors.black,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
