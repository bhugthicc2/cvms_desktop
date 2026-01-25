import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
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
          hasButtons: false,

          title: widget.title,
          height: screenHeight * 0.7,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: buildInfoSection(
                          context,
                          'Fullname',
                          _fullnameCtrl.text,
                        ),
                      ),
                      Spacing.horizontal(size: AppIconSizes.medium),
                      Expanded(
                        child: buildInfoSection(
                          context,
                          'School ID',
                          _schoolIdCtrl.text,
                        ),
                      ),
                    ],
                  ),
                  Spacing.vertical(size: AppIconSizes.medium),
                  Row(
                    children: [
                      Expanded(
                        child: buildInfoSection(
                          context,
                          'Gender',
                          _genderCtrl.text,
                        ),
                      ),
                      Spacing.horizontal(size: AppIconSizes.medium),
                      Expanded(
                        child: buildInfoSection(
                          context,
                          'Contact Number',
                          _contactCtrl.text,
                        ),
                      ),
                    ],
                  ),
                  Spacing.vertical(size: AppIconSizes.medium),
                  Row(
                    children: [
                      Expanded(
                        child: buildInfoSection(
                          context,
                          'Purok',
                          _purokCtrl.text,
                        ),
                      ),
                      Spacing.horizontal(size: AppIconSizes.medium),
                      Expanded(
                        child: buildInfoSection(
                          context,
                          'Barangay',
                          _barangayCtrl.text,
                        ),
                      ),
                    ],
                  ),
                  Spacing.vertical(size: AppIconSizes.medium),
                  Row(
                    children: [
                      Expanded(
                        child: buildInfoSection(
                          context,
                          'City/Municipality',
                          _cityCtrl.text,
                        ),
                      ),
                      Spacing.horizontal(size: AppIconSizes.medium),
                      Expanded(
                        child: buildInfoSection(
                          context,
                          'Province',
                          _provinceCtrl.text,
                        ),
                      ),
                    ],
                  ),
                  Spacing.vertical(size: AppIconSizes.medium),

                  Row(
                    children: [
                      Expanded(
                        child: buildInfoSection(
                          context,
                          'Course',
                          _courseCtrl.text,
                        ),
                      ),
                      Spacing.horizontal(size: AppIconSizes.medium),
                      Expanded(
                        child: buildInfoSection(
                          context,
                          'Year Level',
                          _yearLevelCtrl.text,
                        ),
                      ),
                    ],
                  ),
                  Spacing.vertical(size: AppIconSizes.medium),
                  Row(
                    children: [
                      Expanded(
                        child: buildInfoSection(
                          context,
                          'Block',
                          _blockCtrl.text,
                        ),
                      ),
                      Spacing.horizontal(size: AppIconSizes.medium),
                      Expanded(
                        child: buildInfoSection(
                          context,
                          'License Number',
                          _licenseNumberCtrl.text,
                        ),
                      ),
                    ],
                  ),
                  Spacing.vertical(size: AppIconSizes.medium),

                  Row(
                    children: [
                      Expanded(
                        child: buildInfoSection(
                          context,
                          'Plate Number',
                          _plateCtrl.text,
                        ),
                      ),
                      Spacing.horizontal(size: AppIconSizes.medium),
                      Expanded(
                        child: buildInfoSection(
                          context,
                          'Vehicle Model',
                          _vehicleModelCtrl.text,
                        ),
                      ),
                    ],
                  ),

                  Spacing.vertical(size: AppIconSizes.medium),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildInfoSection(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
