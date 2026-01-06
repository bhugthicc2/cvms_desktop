import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/core/widgets/skeleton/stats_card_skeleton.dart';
import 'package:flutter/material.dart';

Widget buildSkeletonDashOverview() => Row(
  children: [
    Expanded(child: StatsCard()),
    const Spacing.horizontal(size: AppSpacing.medium),
    Expanded(child: StatsCard()),
    const Spacing.horizontal(size: AppSpacing.medium),
    Expanded(child: StatsCard()),
    const Spacing.horizontal(size: AppSpacing.medium),
    Expanded(child: StatsCard()),
  ],
);
