import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/search_field.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/button/custom_view_button.dart';
import 'package:flutter/material.dart';

class CustomChartTitle extends StatelessWidget {
  final VoidCallback onViewTap;
  final String title;
  final bool showViewBtn;
  final bool showSearchBar;
  final TextEditingController? controller;
  final double searchFieldHeight;
  final bool showSpacer;

  const CustomChartTitle({
    super.key,
    required this.title,
    required this.onViewTap,
    this.showViewBtn = true,
    this.showSearchBar = false,
    this.controller,
    this.searchFieldHeight = 40,
    this.showSpacer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: AppFontSizes.medium,

            fontWeight: FontWeight.w600,
          ),
        ),
        if (showSpacer) Spacer(),
        if (showViewBtn) CustomViewButton(onTap: onViewTap),
        if (showSearchBar && controller != null)
          Expanded(
            child: SearchField(
              searchFieldHeight: searchFieldHeight,
              controller: controller!,
            ),
          ),
      ],
    );
  }
}
