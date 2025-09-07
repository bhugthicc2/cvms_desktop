import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/titles/custom_chart_title.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/chart_data_model.dart';

class BarChartWidget extends StatelessWidget {
  final List<ChartDataModel> data;
  final String title;

  const BarChartWidget({super.key, required this.data, this.title = ''});

  @override
  Widget build(BuildContext context) {
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
                primaryXAxis: CategoryAxis(),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  ColumnSeries<ChartDataModel, String>(
                    dataSource: data,
                    xValueMapper: (d, _) => d.category,
                    yValueMapper: (d, _) => d.value,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
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
          ],
        ),
      ),
    );
  }
}
