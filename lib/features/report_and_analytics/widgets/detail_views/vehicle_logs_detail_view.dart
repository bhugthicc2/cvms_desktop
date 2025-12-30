import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/report_and_analytics/models/chart_data_model.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/charts/line_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class VehicleLogsDetailView extends StatelessWidget {
  final List<ChartDataModel> data;
  final Function(ChartPointDetails)? onLineChartPointTap;

  const VehicleLogsDetailView({
    super.key,
    required this.data,
    this.onLineChartPointTap,
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
              child: LineChartWidget(
                showViewBtn: false,
                onViewTap: () {},
                data: data,
                onLineChartPointTap: onLineChartPointTap,
                title: 'Vehicle Logs Trend',
              ),
            ),
            // Add more content here: data table, filters, etc.
          ],
        ),
      ),
    );
  }
}

//todo add a detailed vehicle logs report (timeline i think) for each vehicle
