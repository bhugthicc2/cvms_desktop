import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/dashboard/models/vehicle_entry.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class VehicleActionsMenu extends StatelessWidget {
  final VehicleEntry vehicleEntry;
  final int rowIndex;
  final BuildContext context;

  const VehicleActionsMenu({
    super.key,
    required this.vehicleEntry,
    required this.rowIndex,
    required this.context,
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
        onSelected: (String value) {
          _handleMenuAction(value, context);
        },
        itemBuilder:
            (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(
                      PhosphorIconsBold.notePencil,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    const Text('Edit Details'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'update',
                child: Row(
                  children: [
                    const Icon(
                      PhosphorIconsBold.arrowsClockwise,
                      size: 16,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    const Text('Update'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'report',
                child: Row(
                  children: [
                    const Icon(
                      PhosphorIconsBold.warning,
                      size: 16,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    const Text('Report'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(
                      PhosphorIconsBold.trash,
                      size: 16,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Delete',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ],
                ),
              ),
            ],
      ),
    );
  }

  void _handleMenuAction(String action, BuildContext context) {
    switch (action) {
      case 'edit':
        _editVehicle(context);
      case 'update':
        _updateVehicle(context);
        break;
      case 'report':
        _reportVehicle(context);
        break;
      case 'delete':
        _deleteVehicle(context);
        break;
    }
  }

  void _editVehicle(BuildContext context) {
    //todo
  }
  void _updateVehicle(BuildContext context) {
    //todo
  }
  void _reportVehicle(BuildContext context) {
    //todo
  }
  void _deleteVehicle(BuildContext context) {
    //todo
  }
}
