import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../models/vehicle_log_model.dart';
import 'package:intl/intl.dart';

class VehicleLogsInfoDialog extends StatelessWidget {
  final VehicleLogModel log;

  const VehicleLogsInfoDialog({super.key, required this.log});

  String _formatDateTime(Timestamp? ts) {
    if (ts == null) return '';
    return DateFormat("dd/MM/yyyy hh:mm a").format(ts.toDate());
  }

  String _formatDuration(Duration duration) {
    return '${duration.inHours}h ${duration.inMinutes % 60}m';
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Vehicle Log Information',
      icon: PhosphorIconsBold.car,
      mainContentPadding: 20,
      btnTxt: 'Close',
      width: 600,
      height: 445,
      onSubmit: () => Navigator.of(context).pop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fullname & Vehicle
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  labelText: 'Onwer Name',
                  controller: TextEditingController(text: log.ownerName),
                  enabled: false,
                  height: 55,
                ),
              ),
              Spacing.horizontal(size: AppIconSizes.medium),
              Expanded(
                child: CustomTextField(
                  labelText: 'Vehicle',
                  controller: TextEditingController(text: log.vehicleModel),
                  enabled: false,
                  height: 55,
                ),
              ),
            ],
          ),
          Spacing.vertical(size: AppIconSizes.medium),

          // Plate Number & Status
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  labelText: 'Plate Number',
                  controller: TextEditingController(text: log.plateNumber),
                  enabled: false,
                  height: 55,
                ),
              ),
              Spacing.horizontal(size: AppIconSizes.medium),
              Expanded(
                child: CustomTextField(
                  labelText: 'Status',
                  controller: TextEditingController(
                    text: log.status.toUpperCase(),
                  ),
                  enabled: false,
                  height: 55,
                ),
              ),
            ],
          ),
          Spacing.vertical(size: AppIconSizes.medium),

          // Duration
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  labelText: 'Duration',
                  controller: TextEditingController(
                    text: _formatDuration(
                      Duration(minutes: log.durationMinutes ?? 0),
                    ),
                  ),
                  enabled: false,
                  height: 55,
                ),
              ),
              Spacing.horizontal(size: AppIconSizes.medium),
              const Expanded(
                child: SizedBox(), // keeps row alignment clean
              ),
            ],
          ),

          // Entry / Exit times
          ...[
            Spacing.vertical(size: AppIconSizes.medium),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    labelText: 'Entry Time',
                    controller: TextEditingController(
                      text: _formatDateTime(log.timeIn),
                    ),
                    enabled: false,
                    height: 55,
                  ),
                ),
                Spacing.horizontal(size: AppIconSizes.medium),
                Expanded(
                  child:
                      log.timeOut != null
                          ? CustomTextField(
                            labelText: 'Exit Time',
                            controller: TextEditingController(
                              text: _formatDateTime(log.timeOut),
                            ),

                            enabled: false,
                            height: 55,
                          )
                          : const SizedBox(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
