import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown_field.dart';
import 'package:flutter/material.dart';

class CustomUpdateStatusDialog extends StatefulWidget {
  final String vehicleID;
  final String currentStatus;
  final Function(String newStatus) onSave;

  const CustomUpdateStatusDialog({
    super.key,
    required this.vehicleID,
    required this.currentStatus,
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
    return CustomDialog(
      height: 250,
      width: 600,
      title: 'Update Vehicle Status',
      btnTxt: 'Update',
      onSubmit: () {
        if (_selectedStatus != null) {
          widget.onSave(_selectedStatus!);
          Navigator.of(context).pop();
        }
      },
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
