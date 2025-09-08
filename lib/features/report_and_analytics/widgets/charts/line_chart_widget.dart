import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/titles/custom_chart_title.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/chart_data_model.dart';

class LineChartWidget extends StatelessWidget {
  final List<ChartDataModel> data;
  final String title;

  const LineChartWidget({super.key, required this.data, this.title = ''});

  @override
  Widget build(BuildContext context) {
    final points = data.where((d) => d.date != null).toList();
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (title.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: CustomChartTitle(title: title),
              ),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  LineSeries<ChartDataModel, DateTime>(
                    dataSource: points,
                    xValueMapper: (d, _) => d.date!,
                    yValueMapper: (d, _) => d.value,
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: AppColors.chartGreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
