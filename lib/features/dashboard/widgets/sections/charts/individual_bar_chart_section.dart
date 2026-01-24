import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_slide.dart';
import 'package:cvms_desktop/core/widgets/charts/bar_chart_widget.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:flutter/material.dart';

class IndividualBarChartSection extends StatelessWidget {
  //model
  final List<ChartDataModel>? violationDistribution;
  // Chart view tap handlers
  final VoidCallback? onViolationDistributionTap;
  //hover
  final double hoverDy;
  const IndividualBarChartSection({
    super.key,
    required this.violationDistribution,
    this.onViolationDistributionTap,
    this.hoverDy = -0.01,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0,
        AppSpacing.medium,
        AppSpacing.medium,
        AppSpacing.medium,
      ),
      child: _buildBarChart(
        'Violations by Type',
        violationDistribution ?? [],
        onViolationDistributionTap,
      ),
    );
  }

  Widget _buildBarChart(
    String title,
    List<ChartDataModel> data,
    VoidCallback? onViewTap,
  ) {
    return HoverSlide(
      dx: 0,
      dy: hoverDy,
      child: BarChartWidget(
        data: data,
        title: title,
        onViewTap: onViewTap ?? () {},
        onBarChartPointTap: (details) {},
      ),
    );
  }
}
