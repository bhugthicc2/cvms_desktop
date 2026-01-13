import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'report_table_header.dart';
import '../../tables/violation/global_violation_history_table.dart';
import '../../tables/violation/violation_history_table.dart';

/// Violations Table Section - Displays violation history table with header including:
/// - Global violation history (when isGlobal = true)
/// - Individual violation history (when isGlobal = false)
/// - Sortable table with dark/light header options
class ViolationsTableSection extends StatelessWidget {
  const ViolationsTableSection({super.key, required this.isGlobal});

  final bool isGlobal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.medium,
        AppSpacing.medium,
        AppSpacing.medium,
        0,
      ),
      height: 400,
      decoration: cardDecoration(),
      child: Column(
        children: [
          ReportTableHeader(
            tableTitle:
                isGlobal ? 'Global Violation History' : 'Violation History',
            onTap: () {},
          ),
          Spacing.vertical(size: AppSpacing.medium),
          Expanded(
            child:
                isGlobal
                    ? const GlobalViolationHistoryTable(
                      istableHeaderDark: false,
                      allowSorting: true,
                    )
                    : const ViolationHistoryTable(
                      istableHeaderDark: false,
                      allowSorting: true,
                    ),
          ),
        ],
      ),
    );
  }
}
