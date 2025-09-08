import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomEditDialog extends StatefulWidget {
  final String title;
  final VehicleEntry vehicle;
  final Function(VehicleEntry) onSave;

  const CustomEditDialog({
    super.key,
    required this.title,
    required this.vehicle,
    required this.onSave,
  });

  @override
  State<CustomEditDialog> createState() => _CustomEditDialogState();
}

class _CustomEditDialogState extends State<CustomEditDialog> {
  final Map<String, TextEditingController> _controllers = {
    "Owner Name": TextEditingController(),
    "School ID": TextEditingController(),
    "Plate Number": TextEditingController(),
    "Vehicle Type": TextEditingController(),
    "Vehicle Model": TextEditingController(),
    "Vehicle Color": TextEditingController(),
    "License Number": TextEditingController(),
    "OR Number": TextEditingController(),
    "CR Number": TextEditingController(),
    "Status": TextEditingController(),
    "QR Code ID": TextEditingController(),
  };

  String? _createdAt;

  @override
  void initState() {
    super.initState();

    _controllers["Owner Name"]!.text = widget.vehicle.ownerName;
    _controllers["School ID"]!.text = widget.vehicle.schoolID;
    _controllers["Plate Number"]!.text = widget.vehicle.plateNumber;
    _controllers["Vehicle Type"]!.text = widget.vehicle.vehicleType;
    _controllers["Vehicle Model"]!.text = widget.vehicle.vehicleModel;
    _controllers["Vehicle Color"]!.text = widget.vehicle.vehicleColor;
    _controllers["License Number"]!.text = widget.vehicle.licenseNumber;
    _controllers["OR Number"]!.text = widget.vehicle.orNumber;
    _controllers["CR Number"]!.text = widget.vehicle.crNumber;
    _controllers["Status"]!.text = widget.vehicle.status;
    _controllers["QR Code ID"]!.text = widget.vehicle.qrCodeID;

    if (widget.vehicle.createdAt != null) {
      _createdAt = widget.vehicle.createdAt!.toDate().toIso8601String();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final fieldPairs = [
      ["Owner Name", "School ID"],
      ["Plate Number", "Vehicle Type"],
      ["Vehicle Model", "Vehicle Color"],
      ["License Number", "OR Number"],
      ["CR Number", "Status"],
      ["QR Code ID", ""],
    ];

    return CustomDialog(
      icon: PhosphorIconsBold.motorcycle,
      btnTxt: 'Update',
      onSubmit: () => _handleSave(context),
      title: widget.title,
      height: screenHeight * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Spacing.vertical(size: AppSpacing.small),

            for (var pair in fieldPairs) ...[
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      labelText: pair[0],
                      controller: _controllers[pair[0]]!,
                    ),
                  ),
                  if (pair[1].isNotEmpty) ...[
                    Spacing.horizontal(size: AppIconSizes.medium),
                    Expanded(
                      child: CustomTextField(
                        labelText: pair[1],
                        controller: _controllers[pair[1]]!,
                      ),
                    ),
                  ],
                ],
              ),
              Spacing.vertical(size: AppSpacing.medium),
            ],

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    labelText: 'Created At',
                    controller: TextEditingController(text: _createdAt ?? ''),
                    enabled: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleSave(BuildContext context) {
    final entry = VehicleEntry(
      vehicleID: widget.vehicle.vehicleID,
      ownerName: _controllers["Owner Name"]!.text,
      schoolID: _controllers["School ID"]!.text,
      plateNumber: _controllers["Plate Number"]!.text,
      vehicleType: _controllers["Vehicle Type"]!.text,
      vehicleModel: _controllers["Vehicle Model"]!.text,
      vehicleColor: _controllers["Vehicle Color"]!.text,
      licenseNumber: _controllers["License Number"]!.text,
      orNumber: _controllers["OR Number"]!.text,
      crNumber: _controllers["CR Number"]!.text,
      status: _controllers["Status"]!.text,
      qrCodeID: _controllers["QR Code ID"]!.text,
      createdAt: widget.vehicle.createdAt,
    );

    widget.onSave(entry);
    Navigator.of(context).pop();
  }
}
