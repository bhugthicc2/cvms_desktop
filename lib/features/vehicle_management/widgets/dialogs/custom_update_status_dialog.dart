import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown_field.dart';
import 'package:flutter/material.dart';

class CustomUpdateStatusDialog extends StatefulWidget {
  final String? vehicleID;
  final String? currentStatus;
  final int? selectedCount;
  final Function(String newStatus) onSave;

  const CustomUpdateStatusDialog({
    super.key,
    this.vehicleID,
    this.currentStatus,
    this.selectedCount,
    required this.onSave,
  });

  @override
  State<CustomUpdateStatusDialog> createState() =>
      _CustomUpdateStatusDialogState();
}

class _CustomUpdateStatusDialogState extends State<CustomUpdateStatusDialog> {
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    final hasChanged = _selectedStatus != widget.currentStatus;
    final isBulkOperation =
        widget.selectedCount != null && widget.selectedCount! > 1;

    return CustomDialog(
      height: 250,
      width: 600,
      title:
          isBulkOperation
              ? 'Update Status (${widget.selectedCount} vehicles)'
              : 'Update Vehicle Status',
      btnTxt: 'Update',
      onSubmit:
          (isBulkOperation ? _selectedStatus != null : hasChanged)
              ? () {
                widget.onSave(_selectedStatus!);
                Navigator.of(context).pop();
              }
              : null,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomDropdownField<String>(
          value: _selectedStatus,
          labelText: "Vehicle Status",
          hintText: "Select status",
          items: const [
            DropdownItem(value: 'inside', label: 'Inside'),
            DropdownItem(value: 'outside', label: 'Outside'),
          ],
          onChanged: (status) => setState(() => _selectedStatus = status),
        ),
      ),
    );
  }
}
