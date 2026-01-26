import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StatsCardSection extends StatelessWidget {
  final String statsCard1Label;
  final dynamic statsCard1Value;
  final IconData? statsCard1Icon;
  final String statsCard2Label;
  final dynamic statsCard2Value;
  final IconData? statsCard2Icon;
  final String statsCard3Label;
  final dynamic statsCard3Value;
  final IconData? statsCard3Icon;
  final String statsCard4Label;
  final dynamic statsCard4Value;
  final IconData? statsCard4Icon;
  final bool isGlobal;
  final VoidCallback? onStatsCard1Click;
  final VoidCallback? onStatsCard2Click;
  final VoidCallback? onStatsCard3Click;
  final VoidCallback? onStatsCard4Click;
  final double hoverDy;
  final double statsCardRadii;
  final double iconContainerRadii;
  final bool addSideBorder;

  const StatsCardSection({
    super.key,
    required this.statsCard1Label,
    required this.statsCard1Value,
    this.statsCard1Icon,
    required this.statsCard2Label,
    required this.statsCard2Value,
    this.statsCard2Icon,
    required this.statsCard3Label,
    required this.statsCard3Value,
    this.statsCard3Icon,
    required this.statsCard4Label,
    required this.statsCard4Value,
    this.statsCard4Icon,
    this.isGlobal = true,
    this.onStatsCard1Click,
    this.onStatsCard2Click,
    this.onStatsCard3Click,
    this.onStatsCard4Click,
    this.hoverDy = -0.01,
    this.statsCardRadii = 8,
    this.iconContainerRadii = 4,
    this.addSideBorder = false,
    //
  });

  @override
  Widget build(BuildContext context) {
    return isGlobal ? _buildGlobalStatsCard() : _buildIndividualStatsCard();
  }

  Widget _buildGlobalStatsCard() {
    return
    //  Column(
    //   children: [
    Row(
      children: [
        Expanded(
          child: StatsCard(
            addSideBorder: addSideBorder,
            iconContainerRadii: iconContainerRadii,
            cardBorderRadii: statsCardRadii,
            onClick: onStatsCard1Click,
            label: statsCard1Label,
            value: statsCard1Value,
            icon: PhosphorIconsBold.calendarMinus,
            color: Colors.blue,
            gradient: AppColors.blueViolet,
            iconColor: AppColors.donutPink,
            hoverDy: hoverDy,
          ),
        ),
        Spacing.horizontal(size: AppSpacing.medium),
        Expanded(
          child: StatsCard(
            addSideBorder: addSideBorder,
            iconContainerRadii: iconContainerRadii,
            cardBorderRadii: statsCardRadii,
            onClick: onStatsCard2Click,
            label: statsCard2Label,
            value: statsCard2Value,
            icon: PhosphorIconsBold.warning,
            color: AppColors.orange,
            gradient: AppColors.yellowOrange,
            iconColor: AppColors.orange,
            hoverDy: hoverDy,
          ),
        ),
        Spacing.horizontal(size: AppSpacing.medium),
        Expanded(
          child: StatsCard(
            addSideBorder: addSideBorder,
            iconContainerRadii: iconContainerRadii,
            cardBorderRadii: statsCardRadii,
            onClick: onStatsCard3Click,
            label: statsCard3Label,
            value: statsCard3Value,
            icon: PhosphorIconsBold.car,
            color: AppColors.donutBlue,
            gradient: AppColors.purpleBlue,
            iconColor: AppColors.donutBlue,
            hoverDy: hoverDy,
          ),
        ),
        Spacing.horizontal(size: AppSpacing.medium),
        Expanded(
          child: StatsCard(
            addSideBorder: addSideBorder,
            iconContainerRadii: iconContainerRadii,
            cardBorderRadii: statsCardRadii,
            onClick: onStatsCard4Click,
            label: statsCard4Label,
            value: statsCard4Value,
            icon: statsCard4Icon ?? Icons.trending_up,
            color: AppColors.chartGreen,
            gradient: AppColors.greenWhite,
            iconColor: AppColors.chartGreen,
            hoverDy: hoverDy,
          ),
        ),
      ],
      // ),

      //   Spacing.vertical(size: AppSpacing.medium),

      //   Row(
      //     children: [
      //       Expanded(
      //         child: StatsCard(
      //           addSideBorder: addSideBorder,
      //           iconContainerRadii: iconContainerRadii,
      //           cardBorderRadii: statsCardRadii,
      //           onClick: onStatsCard1Click,
      //           label: statsCard1Label,
      //           value: statsCard1Value,
      //           icon: PhosphorIconsBold.calendarMinus,
      //           color: Colors.blue,
      //           gradient: AppColors.blueViolet,
      //           iconColor: AppColors.donutPink,
      //           hoverDy: hoverDy,
      //         ),
      //       ),
      //       Spacing.horizontal(size: AppSpacing.medium),
      //       Expanded(
      //         child: StatsCard(
      //           addSideBorder: addSideBorder,
      //           iconContainerRadii: iconContainerRadii,
      //           cardBorderRadii: statsCardRadii,
      //           onClick: onStatsCard2Click,
      //           label: statsCard2Label,
      //           value: statsCard2Value,
      //           icon: PhosphorIconsBold.warning,
      //           color: AppColors.orange,
      //           gradient: AppColors.yellowOrange,
      //           iconColor: AppColors.orange,
      //           hoverDy: hoverDy,
      //         ),
      //       ),
      //       Spacing.horizontal(size: AppSpacing.medium),
      //       Expanded(
      //         child: StatsCard(
      //           addSideBorder: addSideBorder,
      //           iconContainerRadii: iconContainerRadii,
      //           cardBorderRadii: statsCardRadii,
      //           onClick: onStatsCard3Click,
      //           label: statsCard3Label,
      //           value: statsCard3Value,
      //           icon: PhosphorIconsBold.car,
      //           color: AppColors.donutBlue,
      //           gradient: AppColors.purpleBlue,
      //           iconColor: AppColors.donutBlue,
      //           hoverDy: hoverDy,
      //         ),
      //       ),
      //       Spacing.horizontal(size: AppSpacing.medium),
      //       Expanded(
      //         child: StatsCard(
      //           addSideBorder: addSideBorder,
      //           iconContainerRadii: iconContainerRadii,
      //           cardBorderRadii: statsCardRadii,
      //           onClick: onStatsCard4Click,
      //           label: statsCard4Label,
      //           value: statsCard4Value,
      //           icon: statsCard4Icon ?? Icons.trending_up,
      //           color: AppColors.chartGreen,
      //           gradient: AppColors.greenWhite,
      //           iconColor: AppColors.chartGreen,
      //           hoverDy: hoverDy,
      //         ),
      //       ),
      //     ],
      //   ),
      //],
    );
  }

  Widget _buildIndividualStatsCard() {
    return Row(
      children: [
        Expanded(
          child: StatsCard(
            iconContainerRadii: iconContainerRadii,
            cardBorderRadii: statsCardRadii,
            onClick: onStatsCard1Click,
            gradient: AppColors.greenWhite,
            // addSideBorder: false,
            label: statsCard1Label,
            value: statsCard1Value,
            icon: statsCard1Icon ?? Icons.dashboard,
            color: Colors.blue,
            iconColor: Colors.blue,
            hoverDy: hoverDy,
          ),
        ),
        Spacing.horizontal(size: AppSpacing.medium),
        Expanded(
          child: StatsCard(
            iconContainerRadii: iconContainerRadii,
            cardBorderRadii: statsCardRadii,
            onClick: onStatsCard2Click,
            // addSideBorder: false,
            gradient: AppColors.yellowOrange,
            label: statsCard2Label,
            value: statsCard2Value,
            icon: statsCard2Icon ?? Icons.warning,
            color: Colors.orange,
            iconColor: Colors.orange,
            hoverDy: hoverDy,
          ),
        ),

        Spacing.horizontal(size: AppSpacing.medium),

        Expanded(
          child: StatsCard(
            iconContainerRadii: iconContainerRadii,
            cardBorderRadii: statsCardRadii,
            onClick: onStatsCard3Click,
            // addSideBorder: false,
            label: statsCard3Label,
            value: statsCard3Value,
            icon: statsCard3Icon ?? Icons.error,
            color: Colors.red,
            gradient: AppColors.pinkWhite,
            iconColor: Colors.red,
            hoverDy: hoverDy,
          ),
        ),
        Spacing.horizontal(size: AppSpacing.medium),
        Expanded(
          child: StatsCard(
            iconContainerRadii: iconContainerRadii,
            cardBorderRadii: statsCardRadii,
            onClick: onStatsCard4Click,
            // addSideBorder: false,
            label: statsCard4Label,
            value: statsCard4Value,
            icon: statsCard4Icon ?? Icons.trending_up,
            color: AppColors.donutBlue,
            gradient: AppColors.purpleBlue,
            iconColor: Colors.green,
            hoverDy: hoverDy,
          ),
        ),
      ],
    );
  }
}
