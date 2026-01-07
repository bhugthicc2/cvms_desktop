import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/dashboard/widgets/titles/custom_chart_title.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/chart_data_model.dart';

class StackedBarWidget extends StatelessWidget {
  final List<ChartDataModel> data;
  final VoidCallback onViewTap;
  final String title;
  final Function(ChartPointDetails)? onStackBarPointTapped;

  const StackedBarWidget({
    super.key,
    required this.data,
    this.title = '',
    this.onStackBarPointTapped,
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

    // Calculate total for percentage
    final total = data.fold<double>(0, (sum, item) => sum + item.value);

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
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  BarSeries<ChartDataModel, String>(
                    onPointTap: onStackBarPointTapped,
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
                        final percentage =
                            total > 0 ? (value / total * 100) : 0;
                        return Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
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
            ),
          ],
        ),
      ),
    );
  }
}
