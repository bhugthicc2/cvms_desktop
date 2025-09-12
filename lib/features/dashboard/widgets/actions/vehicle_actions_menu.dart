import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/dashboard/models/vehicle_entry.dart';
import 'package:cvms_desktop/core/widgets/app/pop_up_menu_item.dart';
import 'package:cvms_desktop/features/dashboard/widgets/dialogs/custom_delete_dialog.dart'
    show CustomDeleteDialog;
import 'package:cvms_desktop/features/dashboard/widgets/dialogs/custom_view_dialog.dart';
import 'package:cvms_desktop/features/dashboard/widgets/dialogs/reprort_vehicle_dialog.dart';
import 'package:cvms_desktop/features/dashboard/widgets/dialogs/custom_update_dialog.dart';

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
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        onSelected: (String value) {
          _handleMenuAction(value, context);
        },
        itemBuilder:
            (BuildContext context) => [
              CustomPopupMenuItem(
                itemIcon: PhosphorIconsBold.notePencil,
                itemLabel: 'Edit Details',
                value: 'edit',
                iconColor: AppColors.primary,
                textColor: AppColors.primary,
              ),
              CustomPopupMenuItem(
                itemIcon: PhosphorIconsBold.arrowsClockwise,
                itemLabel: 'Update',
                value: 'update',
                iconColor: AppColors.success,
              ),
              CustomPopupMenuItem(
                itemIcon: PhosphorIconsBold.warning,
                itemLabel: 'Report',
                value: 'report',
                iconColor: AppColors.error,
              ),
              CustomPopupMenuItem(
                itemIcon: PhosphorIconsBold.trash,
                itemLabel: 'Delete',
                value: 'delete',
                iconColor: AppColors.error,
                textColor: AppColors.error,
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
    showDialog(
      context: context,
      builder: (_) => const CustomViewDialog(title: "Edit Vehicle Information"),
    );
  }

  void _updateVehicle(BuildContext context) {
    //todo
    showDialog(context: context, builder: (_) => const CustomUpdateDialog());
  }

  void _reportVehicle(BuildContext context) {
    //todo
    showDialog(
      context: context,
      builder: (_) => const ReportVehicleDialog(title: "Report Vehicle"),
    );
  }

  void _deleteVehicle(BuildContext context) {
    //todo
    showDialog(
      context: context,
      builder: (_) => const CustomDeleteDialog(title: "Delete Vehicle"),
    );
  }
}
