//ACTIVITY LOG 11

import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/activity_logs_cubit.dart';
import '../bloc/activity_logs_state.dart';
import '../widgets/tables/activity_logs_table.dart';

class ActivityLogsPage extends StatefulWidget {
  const ActivityLogsPage({super.key});

  @override
  State<ActivityLogsPage> createState() => _ActivityLogsPageState();
}

class _ActivityLogsPageState extends State<ActivityLogsPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load activity logs when page initializes
    Future.microtask(() {
      if (mounted) {
        context.read<ActivityLogsCubit>().loadLogs();
      }
    });

    // Add search controller listener
    searchController.addListener(() {
      context.read<ActivityLogsCubit>().filterEntries(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ActivityLogsCubit, ActivityLogsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ); //todo change into skeletonizer or lottie loading animation
            }

            if (state.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error loading activity logs',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.error!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ActivityLogsCubit>().refreshLogs();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return Row(
              children: [
                // Activity Logs Table
                Expanded(
                  child: ActivityLogsTable(
                    title: "Activity Logs",
                    logs: state.filteredEntries,
                    userFullnames: state.userFullnames,
                    userRoles: state.userRoles,
                    searchController: searchController,
                    hasSearchQuery: searchController.text.isNotEmpty,
                    onCellTap: (details) {
                      // Handle cell tap if needed
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
