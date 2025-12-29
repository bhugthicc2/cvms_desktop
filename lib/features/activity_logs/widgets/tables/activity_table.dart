import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/table/custom_table.dart';
import 'package:cvms_desktop/features/activity_logs/bloc/activity_logs_cubit.dart';
import 'package:cvms_desktop/features/activity_logs/models/activity_entry.dart';
import 'package:cvms_desktop/features/activity_logs/widgets/actions/toggle_actions.dart';
import 'package:cvms_desktop/features/activity_logs/widgets/datasource/activity_logs_data_source.dart';
import 'package:cvms_desktop/features/activity_logs/widgets/tables/activity_table_columns.dart';
import 'package:cvms_desktop/features/activity_logs/widgets/tables/table_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityTable extends StatelessWidget {
  final String title;
  final List<ActivityLog> logs;
  final TextEditingController searchController;

  const ActivityTable({
    super.key,
    required this.title,
    required this.logs,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityLogsCubit, ActivityLogsState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Table Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const Divider(height: 1, thickness: 1),

              // Search and Filters
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TableHeader(searchController: searchController),
              ),

              // Bulk Actions
              if (state.isBulkModeEnabled && state.selectedLogs.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  color: AppColors.primary.withOpacity(0.05),
                  child: Row(
                    children: [
                      Text(
                        '${state.selectedLogs.length} selected',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      // ToggleActions(
                      //   onDelete: () {
                      //     context.read<ActivityLogsCubit>().deleteSelectedLogs();
                      //   },
                      // ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
              ],

              // Data Table
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomTable(
                    dataSource: ActivityLogsDataSource(
                      showCheckbox: state.isBulkModeEnabled,
                      context: context,
                      activityLogs: logs,
                    ),
                    columns: ActivityTableColumns.getColumns(
                      showCheckbox: state.isBulkModeEnabled,
                    ),
                    onSearchCleared: () {
                      searchController.clear();
                      context.read<ActivityLogsCubit>().setSearchQuery('');
                    },
                  ),
                ),
              ),

              // Pagination
              if (logs.isNotEmpty) ...[
                const Divider(height: 1, thickness: 1),
                _buildPagination(context, state),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildPagination(BuildContext context, ActivityLogsState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${state.filteredLogs.length} of ${state.allLogs.length} logs',
            style: const TextStyle(fontSize: 12, color: AppColors.black),
          ),
          // Row(
          //   children: [
          //     IconButton(
          //       icon: const Icon(Icons.chevron_left, size: 20),
          //       onPressed:
          //           state.hasPreviousPage
          //               ? () => context.read<ActivityLogsCubit>().previousPage()
          //               : null,
          //       color:
          //           state.hasPreviousPage
          //               ? AppColors.primary
          //               : AppColors.textHint,
          //       padding: EdgeInsets.zero,
          //       constraints: const BoxConstraints(),
          //       iconSize: 20,
          //     ),
          //     const SizedBox(width: 8),
          //     Text(
          //       'Page ${state.currentPage} of ${state.totalPages}',
          //       style: const TextStyle(fontSize: 12),
          //     ),
          //     const SizedBox(width: 8),
          //     IconButton(
          //       icon: const Icon(Icons.chevron_right, size: 20),
          //       onPressed:
          //           state.hasNextPage
          //               ? () => context.read<ActivityLogsCubit>().nextPage()
          //               : null,
          //       color:
          //           state.hasNextPage ? AppColors.primary : AppColors.textHint,
          //       padding: EdgeInsets.zero,
          //       constraints: const BoxConstraints(),
          //       iconSize: 20,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
