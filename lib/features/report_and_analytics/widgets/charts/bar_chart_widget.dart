import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/titles/custom_chart_title.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/chart_data_model.dart';

class BarChartWidget extends StatelessWidget {
  final List<ChartDataModel> data;
  final VoidCallback onViewTap;
  final String title;
  final Function(ChartPointDetails)? onBarChartPointTap;

  const BarChartWidget({
    super.key,
    required this.data,
    this.title = '',
    this.onBarChartPointTap,
    required this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    // Safety check: return empty state if data is empty
    if (data.isEmpty) {
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
        child: const Center(child: Text('No data available')),
      );
    }

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
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (title.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: CustomChartTitle(title: title, onViewTap: onViewTap),
              ),
            Expanded(
              child: MouseRegion(
                cursor:
                    onBarChartPointTap != null
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    // labelRotation: -45,
                    labelIntersectAction:
                        AxisLabelIntersectAction.wrap, // Allow wrapping
                    labelStyle: const TextStyle(
                      fontSize:
                          AppFontSizes.small -
                          2, // Slightly smaller text to fit better
                    ),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries>[
                    ColumnSeries<ChartDataModel, String>(
                      onPointTap:
                          onBarChartPointTap != null
                              ? (details) => onBarChartPointTap!(details)
                              : null,
                      dataSource: data,
                      xValueMapper: (d, _) => d.category,
                      yValueMapper: (d, _) => d.value,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
