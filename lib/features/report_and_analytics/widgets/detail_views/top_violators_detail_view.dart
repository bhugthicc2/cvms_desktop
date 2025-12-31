import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/report_and_analytics/models/chart_data_model.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/charts/stacked_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TopViolatorsDetailView extends StatelessWidget {
  final List<ChartDataModel> data;
  final Function(ChartPointDetails)? onStackBarPointTapped;

  const TopViolatorsDetailView({
    super.key,
    required this.data,
    this.onStackBarPointTapped,
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
              child: Container(
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
                child: Center(child: Text('Top Violators')),
              ),
            ),
            // Add more content here: data table, filters, etc.
          ],
        ),
      ),
    );
  }
}

//todo add a detailed violation report of each vehicle/student
