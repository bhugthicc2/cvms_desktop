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
    final double total = data.fold<double>(0, (sum, d) => sum + d.value);
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 180,
                    padding: const EdgeInsets.only(right: AppSpacing.medium),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < data.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //dot color
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: () {
                                      final colors = [
                                        AppColors.donutBlue,
                                        AppColors.donutPurple,
                                        AppColors.chartOrange,
                                        AppColors.chartGreen,
                                        AppColors.chartGreenv2,
                                        AppColors.donutPink,
                                      ];
                                      return colors[i % colors.length];
                                    }(),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                //category label
                                Expanded(
                                  child: Text(
                                    data[i].category,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                const SizedBox(width: 10),
                                //value
                                Text(
                                  data[i].value % 1 == 0
                                      ? data[i].value.toInt().toString()
                                      : data[i].value.toString(),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SfCircularChart(
                      legend: const Legend(isVisible: false),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CircularSeries>[
                        DoughnutSeries<ChartDataModel, String>(
                          dataSource: data,
                          xValueMapper: (d, _) => d.category,
                          yValueMapper: (d, _) => d.value,
                          dataLabelMapper: (d, _) {
                            final v = d.value;
                            if (total == 0) return '0%';
                            final pct = (v / total) * 100;
                            return '${pct.toStringAsFixed(1)}%';
                          },
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.inside,
                            textStyle: TextStyle(color: AppColors.white),
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
          ],
        ),
      ),
    );
  }
}
