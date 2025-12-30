import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/report_and_analytics/models/chart_data_model.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/charts/bar_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TopViolationsDetailView extends StatelessWidget {
  final List<ChartDataModel> data;
  final Function(ChartPointDetails)? onBarChartPointTap;

  const TopViolationsDetailView({
    super.key,
    required this.data,
    this.onBarChartPointTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.greySurface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          children: [
            Expanded(
              child: BarChartWidget(
                onViewTap: () {},
                data: data,
                onBarChartPointTap: onBarChartPointTap,
                title: 'Top Violations',
              ),
            ),
            // Add more content here: data table, filters, etc.
          ],
        ),
      ),
    );
  }
}

