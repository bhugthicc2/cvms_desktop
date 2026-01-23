import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_view_button.dart';
import 'package:cvms_desktop/core/widgets/charts/chart_empty_state.dart';
import 'package:cvms_desktop/core/widgets/titles/custom_chart_title.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

    // Smart day format that shows month only for first day or month change
    DateFormat getSmartDayFormat(DateTime firstDate) {
      // This is a simplified approach - for true smart labeling,
      // we'd need to use onLabelRender or create custom labels
      return DateFormat('MMM d');
    }

    // Smart month format that shows year only for first month
    DateFormat getSmartMonthFormat(DateTime firstDate) {
      // This is a simplified approach - for true smart labeling,
      // we'd need to use onLabelRender or create custom labels
      return DateFormat('MMM yyyy');
    }

    // Create dynamic date axis with smart labeling
    DateTimeAxis createSmartDateAxis(double containerWidth) {
      if (points.isEmpty) return DateTimeAxis();

      final firstDate = points.first.date!;
      final lastDate = points.last.date!;
      final totalDays = lastDate.difference(firstDate).inDays;

      // Calculate maximum labels based on container width (~80px per label minimum)
      final maxLabels = (containerWidth / 80).floor().clamp(3, 12);

      // Calculate dynamic interval based on data points and available space
      final dataPointCount = points.length;
      final dynamicInterval = (dataPointCount / maxLabels).ceil().clamp(
        1,
        dataPointCount,
      );

      // Determine the appropriate format based on data span
      if (totalDays <= 6) {
        // For 7 days: Use smart day format with width-aware intervals
        return DateTimeAxis(
          dateFormat: getSmartDayFormat(firstDate),
          labelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          intervalType: DateTimeIntervalType.days,
          interval: dynamicInterval.toDouble(),
          labelRotation: 0,
          maximumLabels: maxLabels,
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        );
      } else if (totalDays <= 29) {
        // For 30 days: Use day format with width-aware intervals
        return DateTimeAxis(
          dateFormat: getSmartDayFormat(firstDate),
          labelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          intervalType: DateTimeIntervalType.days,
          interval:
              dynamicInterval
                  .clamp(1, 7)
                  .toDouble(), // Cap at weekly intervals for 30 days
          labelRotation: 0,
          maximumLabels: maxLabels,
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        );
      } else if (totalDays <= 364) {
        // For yearly data: Use month format with width-aware intervals
        return DateTimeAxis(
          dateFormat: getSmartMonthFormat(firstDate),
          labelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          intervalType: DateTimeIntervalType.months,
          interval:
              (dynamicInterval / 30)
                  .ceil()
                  .clamp(1, 3)
                  .toDouble(), // Convert to monthly intervals
          labelRotation: 0,
          maximumLabels: maxLabels,
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
          edgeLabelPlacement: EdgeLabelPlacement.shift,
        );
      } else {
        // For multi-year data: Use year format with width-aware intervals
        return DateTimeAxis(
          dateFormat: DateFormat('yyyy'),
          labelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          intervalType: DateTimeIntervalType.years,
          interval:
              (dynamicInterval / 365)
                  .ceil()
                  .clamp(1, 10)
                  .toDouble(), // Convert to yearly intervals
          labelRotation: 0,
          maximumLabels: maxLabels,
          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        );
      }
    }

    // Calculate container width (estimate based on typical chart container)
    final containerWidth = MediaQuery.of(context).size.width * 0.6;

    final body = SfCartesianChart(
      primaryXAxis: createSmartDateAxis(containerWidth),
      tooltipBehavior: TooltipBehavior(enable: true),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(
          format: 'point.x: point.y',
          color: Colors.black87,
        ),
        lineType: TrackballLineType.vertical,
        lineColor: AppColors.primary,
        lineWidth: 2,
        markerSettings: const TrackballMarkerSettings(
          markerVisibility: TrackballVisibilityMode.visible,
          color: AppColors.primary,
          borderColor: Colors.white,
          borderWidth: 2,
        ),
      ),
      series: <CartesianSeries>[
        AreaSeries<ChartDataModel, DateTime>(
          onPointTap: onLineChartPointTap,
          dataSource: points,
          xValueMapper: (d, _) => d.date!,
          yValueMapper: (d, _) => d.value,
          markerSettings: const MarkerSettings(isVisible: false),
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.primary.withValues(alpha: 0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderColor: AppColors.primary,
          borderWidth: 2.0,
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
