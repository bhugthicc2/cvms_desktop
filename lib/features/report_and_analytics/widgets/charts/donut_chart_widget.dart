import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/titles/custom_chart_title.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/chart_data_model.dart';

class DonutChartWidget extends StatelessWidget {
  final List<ChartDataModel> data;
  final String title;

  const DonutChartWidget({super.key, required this.data, this.title = ''});

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          children: [
            if (title.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: CustomChartTitle(title: title),
              ),
            Expanded(
              child: SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.left,

                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CircularSeries>[
                  DoughnutSeries<ChartDataModel, String>(
                    dataSource: data,
                    xValueMapper: (d, _) => d.category,
                    yValueMapper: (d, _) => d.value,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: false,
                    ),
                    radius: '90%',
                    innerRadius: '60%',
                    strokeWidth: 2,
                    strokeColor: AppColors.white,
                    pointColorMapper: (data, index) {
                      final colors = [
                        AppColors.donutBlue,
                        AppColors.donutPurple,
                        AppColors.chartOrange,
                        AppColors.chartGreen,
                        AppColors.chartGreenv2,
                        AppColors.donutPink,
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
