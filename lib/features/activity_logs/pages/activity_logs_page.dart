import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/features/activity_logs/bloc/activity_logs_cubit.dart';
import 'package:cvms_desktop/features/activity_logs/data/activity_logs_repository.dart';
import 'package:cvms_desktop/features/activity_logs/models/activity_entry.dart';
import 'package:cvms_desktop/features/activity_logs/widgets/tables/activity_table.dart';

class ActivityLogsPage extends StatefulWidget {
  const ActivityLogsPage({super.key});

  @override
  State<ActivityLogsPage> createState() => _ActivityLogsPageState();
}

class _ActivityLogsPageState extends State<ActivityLogsPage> {
  final TextEditingController searchController = TextEditingController();
  late final ActivityLogsCubit _cubit;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _cubit = ActivityLogsCubit(ActivityLogsRepository());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _cubit.close();
    searchController.dispose();
    super.dispose();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history, color: Colors.grey, size: 48),
          const SizedBox(height: 16),
          Text(
            'No activity logs found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Activity logs will appear here when users perform actions',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            'Failed to load activity logs',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _cubit.init(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<ActivityLog> logs) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: ActivityTable(
        title: "Activity Logs",
        logs: logs,
        searchController: searchController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<ActivityLogsCubit, ActivityLogsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.greySurface,
            body:
                state.error != null
                    ? _buildErrorState(state.error!)
                    : state.allLogs.isEmpty
                    ? _buildEmptyState()
                    : _buildContent(state.filteredLogs),
          );
        },
      ),
    );
  }
}
