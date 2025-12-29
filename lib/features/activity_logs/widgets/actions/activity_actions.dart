import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cvms_desktop/features/activity_logs/bloc/activity_logs_cubit.dart';
import 'package:cvms_desktop/features/activity_logs/models/activity_entry.dart';

class ActivityActions extends StatelessWidget {
  final ActivityLog log;
  final BuildContext context;

  const ActivityActions({super.key, required this.log, required this.context});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // View Details Button
        CustomIconButton(
          onPressed: () {
            _showLogDetails(context, log);
          },
          icon: PhosphorIconsRegular.eye,
          iconColor: AppColors.primary,
        ),

        // Delete Button (only for admins or relevant roles)
        if (_canDeleteLog(log)) ...[
          const SizedBox(width: 8),
          CustomIconButton(
            onPressed: () {
              _confirmDeleteLog(context, log);
            },
            icon: PhosphorIconsRegular.trash,
            iconColor: AppColors.error,
          ),
        ],
      ],
    );
  }

  bool _canDeleteLog(ActivityLog log) {
    // Add your permission logic here
    // For example, only allow deletion by admins or for certain log types
    return true; // Temporary - replace with actual permission check
  }

  void _showLogDetails(BuildContext context, ActivityLog log) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Activity Log Details'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailRow('Type', _formatActivityType(log.type)),
                  _buildDetailRow('Timestamp', _formatTimestamp(log.timestamp)),
                  if (log.userEmail != null)
                    _buildDetailRow('User', log.userEmail!),
                  if (log.targetType != null)
                    _buildDetailRow(
                      'Target',
                      '${log.targetType}: ${log.targetId ?? 'N/A'}',
                    ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'Description',
                    log.description,
                    isMultiline: true,
                  ),
                  if (log.metadata != null && log.metadata!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Additional Information:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...log.metadata!.entries.map(
                      (e) => _buildDetailRow(e.key, e.value.toString()),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _confirmDeleteLog(BuildContext context, ActivityLog log) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this activity log?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  //TODO context.read<ActivityLogsCubit>().deleteSelectedLogs();
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            maxLines: isMultiline ? null : 1,
            overflow: isMultiline ? null : TextOverflow.ellipsis,
          ),
          if (!isMultiline) const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} '
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  String _formatActivityType(ActivityType type) {
    return type
        .toString()
        .split('.')
        .last
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
        .trim();
  }
}
