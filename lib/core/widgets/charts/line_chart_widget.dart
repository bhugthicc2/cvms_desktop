import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/empty_state.dart';
import 'package:cvms_desktop/core/widgets/charts/chart_empty_state.dart';
import 'package:cvms_desktop/features/dashboard/widgets/button/custom_view_button.dart';
import 'package:cvms_desktop/features/dashboard/widgets/titles/custom_chart_title.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../features/dashboard/models/chart_data_model.dart';

class LineChartWidget extends StatelessWidget {
  final List<ChartDataModel> data;
  final String title;
  final Function(ChartPointDetails)? onLineChartPointTap;
  final VoidCallback onViewTap;
  final Widget? customWidget;
  final ScreenshotController? screenshotController;

  const LineChartWidget({
    super.key,
    required this.data,
    this.title = '',
    this.onLineChartPointTap,
    required this.onViewTap,
    this.customWidget,
    this.screenshotController,
  });

  @override
  Widget build(BuildContext context) {
    final points = data.where((d) => d.date != null).toList();

    // Safety check: return empty state if no valid points
    if (data.isEmpty) {
      return Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.all(AppSpacing.medium),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CustomChartTitle(title: title, showViewBtn: false),
            ),
            ChartEmptyState(),
          ],
        ),
      );
    }

    final body = SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries>[
        LineSeries<ChartDataModel, DateTime>(
          onPointTap: onLineChartPointTap,
          dataSource: points,
          xValueMapper: (d, _) => d.date!,
          yValueMapper: (d, _) => d.value,
          markerSettings: const MarkerSettings(isVisible: true),
          color: AppColors.primary,
        ),
      ],
    );

    return Container(
      margin: EdgeInsets.zero,

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            if (title.isNotEmpty)
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,

                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  customWidget ?? const SizedBox.shrink(),
                  Spacer(),
                  CustomViewButton(onTap: onViewTap),
                ],
              ),
            Expanded(
              child:
                  screenshotController == null
                      ? body
                      : Screenshot(
                        controller: screenshotController!,
                        child: body,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
