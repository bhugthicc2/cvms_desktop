import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/charts/chart_empty_state.dart';
import 'package:cvms_desktop/core/widgets/titles/custom_chart_title.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DonutChartWidget extends StatelessWidget {
  final VoidCallback onViewTap;
  final String radius;
  final String innerRadius;
  final List<ChartDataModel> data;
  final String title;
  final bool explode;
  final bool showPercentageInSlice;
  final Function(ChartPointDetails)? onDonutChartPointTap;
  final ScreenshotController? screenshotController;

  const DonutChartWidget({
    super.key,
    required this.data,
    this.title = '',
    this.onDonutChartPointTap,
    required this.onViewTap,
    this.screenshotController,
    this.radius = '90%',
    this.innerRadius = '55%',
    this.explode = false,
    this.showPercentageInSlice = true,
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

    final double total = data.fold<double>(0, (sum, d) => sum + d.value);
    final body = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Stack(
            children: [
              SfCircularChart(
                legend: const Legend(isVisible: false),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CircularSeries>[
                  DoughnutSeries<ChartDataModel, String>(
                    explode: explode,
                    onPointTap: onDonutChartPointTap,
                    dataSource: data,
                    xValueMapper: (d, _) => d.category,
                    yValueMapper: (d, _) => d.value,
                    dataLabelMapper:
                        showPercentageInSlice
                            ? (d, _) {
                              final v = d.value;
                              if (total == 0) return '0%';
                              final pct = (v / total) * 100;
                              return '${pct.toStringAsFixed(1)}%';
                            }
                            : null,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: showPercentageInSlice,
                      labelPosition: ChartDataLabelPosition.inside,
                      textStyle: TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                      ),
                    ),
                    radius: radius,
                    innerRadius: innerRadius,
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
              // Center total value
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      total % 1 == 0
                          ? total.toInt().toString()
                          : total.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
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
                          width: 15,
                          height: 15,
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
                            borderRadius: BorderRadius.circular(5),
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
                        Expanded(
                          child: Text(
                            data[i].value % 1 == 0
                                ? data[i].value.toInt().toString()
                                : data[i].value.toString(),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        //percentage
                        if (!showPercentageInSlice)
                          Expanded(
                            child: Text(() {
                              final v = data[i].value;
                              if (total == 0) return '0%';
                              final pct = (v / total) * 100;
                              return '${pct.toStringAsFixed(1)}%';
                            }(), textAlign: TextAlign.left),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
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
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          children: [
            if (title.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: CustomChartTitle(title: title, onViewTap: onViewTap),
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
