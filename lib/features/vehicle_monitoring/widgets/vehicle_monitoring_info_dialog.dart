import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../models/vehicle_monitoring_entry.dart';

class VehicleMonitoringInfoDialog extends StatelessWidget {
  final VehicleMonitoringEntry entry;

  const VehicleMonitoringInfoDialog({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Vehicle Monitoring Information',
      icon: PhosphorIconsBold.car,
      btnTxt: 'Close',
      width: 600,
      height: 445,
      onSave: () => Navigator.of(context).pop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  labelText: 'Name',
                  controller: TextEditingController(text: entry.name),
                  enabled: false,
                  height: 55,
                ),
              ),
              Spacing.horizontal(size: AppIconSizes.medium),
              Expanded(
                child: CustomTextField(
                  labelText: 'Vehicle',
                  controller: TextEditingController(text: entry.vehicle),
                  enabled: false,
                  height: 55,
                ),
              ),
            ],
          ),
          Spacing.vertical(size: AppIconSizes.medium),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  labelText: 'Plate Number',
                  controller: TextEditingController(text: entry.plateNumber),
                  enabled: false,
                  height: 55,
                ),
              ),
              Spacing.horizontal(size: AppIconSizes.medium),
              Expanded(
                child: CustomTextField(
                  labelText: 'Status',
                  controller: TextEditingController(
                    text: entry.status.toUpperCase(),
                  ),
                  enabled: false,
                  height: 55,
                ),
              ),
            ],
          ),
          Spacing.vertical(size: AppIconSizes.medium),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  labelText: 'Duration',
                  controller: TextEditingController(
                    text:
                        '${entry.duration.inHours}h ${entry.duration.inMinutes % 60}m',
                  ),
                  enabled: false,
                  height: 55,
                ),
              ),
              Spacing.horizontal(size: AppIconSizes.medium),
              Expanded(
                child: CustomTextField(
                  labelText: 'Copy Mock',
                  controller: TextEditingController(
                    text:
                        '${entry.duration.inHours}h ${entry.duration.inMinutes % 60}m',
                  ),
                  enabled: false,
                  height: 55,
                ), // Empty space for alignment
              ),
            ],
          ),
          if (entry.entryTime != null || entry.exitTime != null) ...[
            Spacing.vertical(size: AppIconSizes.medium),
            Row(
              children: [
                Expanded(
                  child:
                      entry.entryTime != null
                          ? CustomTextField(
                            labelText: 'Entry Time',
                            controller: TextEditingController(
                              text:
                                  '${entry.entryTime!.day}/${entry.entryTime!.month}/${entry.entryTime!.year} ${entry.entryTime!.hour}:${entry.entryTime!.minute.toString().padLeft(2, '0')}',
                            ),
                            enabled: false,
                            height: 55,
                          )
                          : Expanded(
                            child: CustomTextField(
                              labelText: 'Copy Mock',
                              controller: TextEditingController(
                                text:
                                    '${entry.duration.inHours}h ${entry.duration.inMinutes % 60}m',
                              ),
                              enabled: false,
                              height: 55,
                            ), // Empty space for alignment
                          ),
                ),
                Spacing.horizontal(size: AppIconSizes.medium),
                Expanded(
                  child:
                      entry.exitTime != null
                          ? CustomTextField(
                            labelText: 'Exit Time',
                            controller: TextEditingController(
                              text:
                                  '${entry.exitTime!.day}/${entry.exitTime!.month}/${entry.exitTime!.year} ${entry.exitTime!.hour}:${entry.exitTime!.minute.toString().padLeft(2, '0')}',
                            ),
                            enabled: false,
                            height: 55,
                          )
                          : Container(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
