import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/bloc/vehicle_monitoring_cubit.dart';

class CustomViewDialog extends StatefulWidget {
  final String title;
  final String vehicleId;
  const CustomViewDialog({
    super.key,
    required this.title,
    required this.vehicleId,
  });

  @override
  State<CustomViewDialog> createState() => _CustomViewDialogState();
}

class _CustomViewDialogState extends State<CustomViewDialog> {
  final _fullnameCtrl = TextEditingController();
  final _schoolIdCtrl = TextEditingController();
  final _genderCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _purokCtrl = TextEditingController();
  final _barangayCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _provinceCtrl = TextEditingController();
  final _parentGuardianCtrl = TextEditingController();
  final _birthdateCtrl = TextEditingController();
  final _courseCtrl = TextEditingController();
  final _yearLevelCtrl = TextEditingController();
  final _blockCtrl = TextEditingController();
  final _enrollmentCtrl = TextEditingController();
  final _licenseNumberCtrl = TextEditingController();
  final _licenseIssueExpiryCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  final _vehicleModelCtrl = TextEditingController();

  bool _initialized = false;
  late final Future<Map<String, dynamic>> _loadVehicleFuture;

  @override
  void initState() {
    super.initState();
    _loadVehicleFuture = context.read<VehicleMonitoringCubit>().getVehicleById(
      widget.vehicleId,
    );
  }

  void _initControllers(Map<String, dynamic> data) {
    if (_initialized) return;
    _fullnameCtrl.text = data['ownerName'] ?? '';
    _schoolIdCtrl.text = data['schoolID'] ?? '';
    _genderCtrl.text = data['gender'] ?? '';
    _contactCtrl.text = data['contact'] ?? '';
    _purokCtrl.text = data['purok'] ?? '';
    _barangayCtrl.text = data['barangay'] ?? '';
    _cityCtrl.text = data['city'] ?? '';
    _provinceCtrl.text = data['province'] ?? '';
    _parentGuardianCtrl.text = data['parentGuardian'] ?? '';
    _birthdateCtrl.text = data['birthdate'] ?? '';
    _courseCtrl.text = data['department'] ?? '';
    _yearLevelCtrl.text = data['yearLevel'] ?? '';
    _blockCtrl.text = data['block'] ?? '';
    _enrollmentCtrl.text = data['enrollment'] ?? '';
    _licenseNumberCtrl.text = data['licenseNumber'] ?? '';
    _licenseIssueExpiryCtrl.text = data['licenseIssueExpiry'] ?? '';
    _plateCtrl.text = data['plateNumber'] ?? '';
    _vehicleModelCtrl.text = data['vehicleModel'] ?? '';
    _initialized = true;
  }

  @override
  void dispose() {
    _fullnameCtrl.dispose();
    _schoolIdCtrl.dispose();
    _genderCtrl.dispose();
    _contactCtrl.dispose();
    _purokCtrl.dispose();
    _barangayCtrl.dispose();
    _cityCtrl.dispose();
    _provinceCtrl.dispose();
    _parentGuardianCtrl.dispose();
    _birthdateCtrl.dispose();
    _courseCtrl.dispose();
    _yearLevelCtrl.dispose();
    _blockCtrl.dispose();
    _enrollmentCtrl.dispose();
    _licenseNumberCtrl.dispose();
    _licenseIssueExpiryCtrl.dispose();
    _plateCtrl.dispose();
    _vehicleModelCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadVehicleFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return CustomDialog(
            btnTxt: 'Close',
            onSubmit: () => Navigator.of(context).pop(),
            title: 'Error',
            height: screenHeight * 0.3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Failed to load vehicle: ${snap.error}'),
            ),
          );
        }
        final data = snap.data ?? {};
        _initControllers(data);

        return CustomDialog(
          btnTxt: 'Save',
          onSubmit: () {
            Navigator.of(context).pop();
          },
          title: widget.title,
          height: screenHeight * 0.9,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Fullname',
                        height: 55,
                        controller: _fullnameCtrl,
                      ),
                    ),
                    Spacing.horizontal(size: AppIconSizes.medium),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'School ID',
                        controller: _schoolIdCtrl,
                      ),
                    ),
                  ],
                ),
                Spacing.vertical(size: AppIconSizes.medium),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Gender',
                        controller: _genderCtrl,
                      ),
                    ),
                    Spacing.horizontal(size: AppIconSizes.medium),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Contact Number',
                        controller: _contactCtrl,
                      ),
                    ),
                  ],
                ),
                Spacing.vertical(size: AppIconSizes.medium),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Purok',
                        controller: _purokCtrl,
                      ),
                    ),
                    Spacing.horizontal(size: AppIconSizes.medium),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Barangay',
                        controller: _barangayCtrl,
                      ),
                    ),
                  ],
                ),
                Spacing.vertical(size: AppIconSizes.medium),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: 'City/Municipality',
                        controller: _cityCtrl,
                      ),
                    ),
                    Spacing.horizontal(size: AppIconSizes.medium),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Province',
                        controller: _provinceCtrl,
                      ),
                    ),
                  ],
                ),
                Spacing.vertical(size: AppIconSizes.medium),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Parent/Guardian',
                        controller: _parentGuardianCtrl,
                      ),
                    ),
                    Spacing.horizontal(size: AppIconSizes.medium),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Birthdate',
                        controller: _birthdateCtrl,
                      ),
                    ),
                  ],
                ),
                Spacing.vertical(size: AppIconSizes.medium),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Course',
                        controller: _courseCtrl,
                      ),
                    ),
                    Spacing.horizontal(size: AppIconSizes.medium),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Year Level',
                        controller: _yearLevelCtrl,
                      ),
                    ),
                  ],
                ),
                Spacing.vertical(size: AppIconSizes.medium),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Block',
                        controller: _blockCtrl,
                      ),
                    ),
                    Spacing.horizontal(size: AppIconSizes.medium),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Enrollment Year & Semester',
                        controller: _enrollmentCtrl,
                      ),
                    ),
                  ],
                ),
                Spacing.vertical(size: AppIconSizes.medium),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: 'License Number',
                        controller: _licenseNumberCtrl,
                      ),
                    ),
                    Spacing.horizontal(size: AppIconSizes.medium),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Issuing date & Expiry date',
                        controller: _licenseIssueExpiryCtrl,
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
                        controller: _plateCtrl,
                      ),
                    ),
                    Spacing.horizontal(size: AppIconSizes.medium),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Vehicle Model',
                        controller: _vehicleModelCtrl,
                      ),
                    ),
                  ],
                ),
                Spacing.vertical(size: AppIconSizes.medium),
              ],
            ),
          ),
        );
      },
    );
  }
}
