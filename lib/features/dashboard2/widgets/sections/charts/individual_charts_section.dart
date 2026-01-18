import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/charts/bar_chart_widget.dart';
import 'package:cvms_desktop/core/widgets/charts/line_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:flutter/material.dart';

class IndividualChartsSection extends StatelessWidget {
  final List<ChartDataModel> violationDistribution;
  final List<ChartDataModel> vehicleLogs;

  const IndividualChartsSection({
    super.key,
    required this.violationDistribution,
    required this.vehicleLogs,
  });

  @override
  Widget build(BuildContext context) {
    double height = 280;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        AppSpacing.medium,
        AppSpacing.medium,
        0,
      ),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(
              child: _buildBarChart(
                'Violations by Type',
                violationDistribution,
              ),
            ),
            Spacing.horizontal(size: AppSpacing.medium),
            Expanded(
              child: _buildLineChart('Vehicle logs for the last', vehicleLogs),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(String title, List<ChartDataModel> data) {
    return BarChartWidget(
      data: data,
      title: title,
      onViewTap: () {},
      onBarChartPointTap: (details) {},
    );
  }

  Widget _buildLineChart(String title, List<ChartDataModel> data) {
    return LineChartWidget(
      data: data,
      title: title,
      onViewTap: () {},
      onLineChartPointTap: (details) {},
    );
  }
}
