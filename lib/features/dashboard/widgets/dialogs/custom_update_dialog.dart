import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown_field.dart';
import 'package:flutter/material.dart';

class CustomUpdateDialog extends StatefulWidget {
  final String? vehicleId;
  final String? currentStatus;
  final int? selectedCount;
  final Function(String newStatus) onSave;

  const CustomUpdateDialog({
    super.key,
    this.vehicleId,
    this.currentStatus,
    this.selectedCount,
    required this.onSave,
  });

  @override
  State<CustomUpdateDialog> createState() => _CustomUpdateStatusDialogState();
}

class _CustomUpdateStatusDialogState extends State<CustomUpdateDialog> {
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
        widget.onSave(_selectedStatus!);
        Navigator.of(context).pop();
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
