import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/charts/chart_empty_state.dart';
import 'package:cvms_desktop/core/widgets/layout/custom_divider.dart';
import 'package:cvms_desktop/core/widgets/titles/custom_chart_title.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChartWidget extends StatelessWidget {
  final List<ChartDataModel> data;
  final VoidCallback onViewTap;
  final String title;
  final Function(ChartPointDetails)? onBarChartPointTap;
  final ScreenshotController? screenshotController;
  final int? highlightHighestIndex;
  final bool enableTooltip;
  final double chartRadii;

  const BarChartWidget({
    super.key,
    required this.data,
    this.title = '',
    this.onBarChartPointTap,
    required this.onViewTap,
    this.screenshotController,
    this.highlightHighestIndex,
    this.enableTooltip = false,
    this.chartRadii = 8,
  });

  @override
  Widget build(BuildContext context) {
    // Safety check: return empty state if data is empty
    if (data.isEmpty) {
      return Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.all(AppSpacing.medium),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(chartRadii),
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
            const Spacer(),
            Center(child: ChartEmptyState()),
            const Spacer(),
          ],
        ),
      );
    }

    // Calculate total for percentage
    final total = data.fold<double>(0, (sum, item) => sum + item.value);

    final body = MouseRegion(
      cursor:
          onBarChartPointTap != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
      child: SfCartesianChart(
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
        primaryXAxis: CategoryAxis(
          labelIntersectAction: AxisLabelIntersectAction.wrap, // Allow wrapping
          labelStyle: const TextStyle(
            fontSize:
                AppFontSizes.small - 2, // Slightly smaller text to fit better
          ),
        ),
        tooltipBehavior: TooltipBehavior(enable: true),

        series: <CartesianSeries>[
          ColumnSeries<ChartDataModel, String>(
            enableTooltip: enableTooltip,
            spacing: 0.2,
            width: 0.6,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            onPointTap:
                onBarChartPointTap != null
                    ? (details) => onBarChartPointTap!(details)
                    : null,
            dataSource: data,
            xValueMapper: (d, _) => d.category,
            yValueMapper: (d, _) => d.value,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              connectorLineSettings: const ConnectorLineSettings(
                type: ConnectorType.line,
                length: '15%',
              ),
              builder: (
                dynamic data,
                dynamic point,
                dynamic series,
                int pointIndex,
                int seriesIndex,
              ) {
                final value = (data as ChartDataModel).value;
                final percentage = total > 0 ? (value / total * 100) : 0;
                final isHighlighted = highlightHighestIndex == pointIndex;

                return Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: isHighlighted ? 12 : 10,
                    fontWeight:
                        isHighlighted ? FontWeight.bold : FontWeight.normal,
                    color: isHighlighted ? AppColors.darkBlue : null,
                  ),
                );
              },
            ),
            pointColorMapper: (data, index) {
              final colors = [
                AppColors.donutBlue,
                AppColors.donutPurple,
                AppColors.chartOrange,
                AppColors.chartGreen,
              ];
              return colors[index % colors.length];
            },
          ),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(chartRadii),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            if (title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomChartTitle(title: title, onViewTap: onViewTap),
                ),
              ),

            CustomDivider(
              direction: Axis.horizontal,
              thickness: 2,
              color: AppColors.greySurface,
            ),

            Expanded(
              child:
                  screenshotController == null
                      ? Padding(
                        padding: const EdgeInsets.all(AppSpacing.medium),
                        child: body,
                      )
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
