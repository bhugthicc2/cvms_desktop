//ACTIVITY LOG 13
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/models/activity_log.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/widgets/app/pop_up_menu_item.dart';

class ActivityLogsActionsMenu extends StatelessWidget {
  final ActivityLog activityLog;
  final int rowIndex;
  final BuildContext context;

  const ActivityLogsActionsMenu({
    super.key,
    required this.rowIndex,
    required this.context,
    required this.activityLog,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: InkRipple.splashFactory,
        highlightColor: AppColors.primary.withValues(alpha: 0.1),
        splashColor: AppColors.primary.withValues(alpha: 0.2),
      ),
      child: PopupMenuButton<String>(
        color: AppColors.white,
        icon: const Icon(Icons.more_horiz, color: AppColors.grey, size: 20),
        splashRadius: 10,
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        onSelected: (String value) {
          _handleMenuAction(value, context);
        },
        itemBuilder:
            (BuildContext context) => [
              CustomPopupMenuItem(
                iconColor: AppColors.primary,
                itemIcon: PhosphorIconsBold.eye,
                itemLabel: 'View Details',
                value: 'view',
              ),
              CustomPopupMenuItem(
                iconColor: AppColors.success,
                itemIcon: PhosphorIconsBold.download,
                itemLabel: 'Export',
                value: 'export',
              ),
            ],
      ),
    );
  }

  void _handleMenuAction(String action, BuildContext context) {
    switch (action) {
      case 'view':
        _viewDetails(context);
        break;

      case 'export':
        _exportLog(context);
        break;
    }
  }

  void _viewDetails(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Activity Log Details'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailRow('Type', activityLog.type.label),
                  _buildDetailRow('Description', activityLog.description),
                  _buildDetailRow('User ID', activityLog.userId ?? 'System'),
                  _buildDetailRow('Target ID', activityLog.targetId ?? '—'),
                  _buildDetailRow(
                    'Timestamp',
                    activityLog.timestamp.toString(),
                  ),
                  if (activityLog.metadata != null) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Metadata:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(activityLog.metadata.toString()),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _exportLog(BuildContext context) {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
