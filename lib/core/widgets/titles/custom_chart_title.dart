import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_view_button.dart';
import 'package:flutter/material.dart';

class CustomChartTitle extends StatelessWidget {
  final VoidCallback? onViewTap;
  final String title;
  final bool showViewBtn;
  const CustomChartTitle({
    super.key,
    required this.title,
    this.onViewTap,
    this.showViewBtn = true,
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
        Spacer(),
        showViewBtn
            ? CustomViewButton(onTap: onViewTap ?? () {})
            : SizedBox.shrink(),
      ],
    );
  }
}
