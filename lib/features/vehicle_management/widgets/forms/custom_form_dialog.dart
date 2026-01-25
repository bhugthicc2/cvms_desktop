import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/date_time_formatter.dart';
import 'package:cvms_desktop/core/utils/form_validator.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/config/location_formatter.dart';
import 'package:cvms_desktop/features/vehicle_management/config/vehicle_form_config.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/fields/custom_barangay_dropdown.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/fields/custom_municipality_dropdown.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/fields/custom_province_dropdown.dart';
import 'package:cvms_desktop/features/vehicle_management/widgets/fields/custom_region_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:philippines_rpcmb/philippines_rpcmb.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

abstract class VehicleFormDialog extends StatefulWidget {
  final String title;
  final Function(VehicleEntry) onSave;
  final VehicleEntry? initialEntry;

  const VehicleFormDialog({
    super.key,
    required this.title,
    required this.onSave,
    this.initialEntry,
  });
}

class VehicleFormDialogState<T extends VehicleFormDialog> extends State<T> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;
  bool _hasChanges = false;

  // Text controllers
  final Map<String, TextEditingController> _controllers = {
    "ownerName": TextEditingController(),
    "schoolID": TextEditingController(),
    "plateNumber": TextEditingController(),
    "vehicleModel": TextEditingController(),
    "licenseNumber": TextEditingController(),
    "orNumber": TextEditingController(),
    "crNumber": TextEditingController(),
    "contact": TextEditingController(),
    "purok": TextEditingController(),
  };

  // Dropdown values
  final Map<String, String?> _dropdownValues = {
    "vehicleType": null,
    "department": null,
    "vehicleColor": null,
    "gender": null,
    "yearLevel": null,
    "block": null,
  };

  // Location state
  Region? _region;
  Province? _province;
  Municipality? _municipality;
  String? _barangay;
  String? _createdAt;

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _controllers.forEach((key, controller) {
      controller.addListener(_updateFormState);
    });
  }

  void _initializeForm() {
    final entry = widget.initialEntry;
    if (entry != null) {
      // Populate text fields
      _controllers.forEach((key, controller) {
        controller.text = _getFieldValue(key, entry);
      });

      // Populate dropdowns
      _dropdownValues.forEach((key, _) {
        _dropdownValues[key] = _getValidDropdownValue(
          key,
          _getFieldValue(key, entry),
        );
      });

      // Initialize location
      _initializeLocation(entry);
      _createdAt =
          entry.createdAt != null
              ? DateTimeFormatter.formatFull(entry.createdAt!.toDate())
              : null;
    } else {
      // Default to Region IX for new entries
      _region = philippineRegions.firstWhere(
        (region) => region.id == '09',
        orElse: () => throw Exception('Region IX not found'),
      );
      _dropdownValues["vehicleType"] = "two-wheeled";
      _createdAt = DateTimeFormatter.formatFull(DateTime.now());
    }
    _updateFormState();
  }

  String _getFieldValue(String key, VehicleEntry entry) {
    switch (key) {
      case "ownerName":
        return entry.ownerName;
      case "schoolID":
        return entry.schoolID;
      case "plateNumber":
        return entry.plateNumber;
      case "vehicleModel":
        return entry.vehicleModel;
      case "licenseNumber":
        return entry.licenseNumber;
      case "orNumber":
        return entry.orNumber;
      case "crNumber":
        return entry.crNumber;
      case "contact":
        return entry.contact;
      case "purok":
        return entry.purok;
      case "vehicleType":
        return entry.vehicleType;
      case "department":
        return entry.department;
      case "vehicleColor":
        return entry.vehicleColor;
      case "gender":
        return entry.gender;
      case "yearLevel":
        return entry.yearLevel;
      case "block":
        return entry.block;
      default:
        return '';
    }
  }

  String? _getValidDropdownValue(String fieldKey, String? value) {
    if (value == null || value.isEmpty) return null;
    final options = VehicleFormConfig.dropdownOptions[fieldKey];
    return options?.any((item) => item.value == value) ?? false ? value : null;
  }

  void _initializeLocation(VehicleEntry? entry) {
    if (entry == null) return;
    for (final region in philippineRegions) {
      for (final province in region.provinces) {
        if (province.name.toLowerCase() == entry.province.toLowerCase()) {
          _region = region;
          _province = province;
          for (final municipality in province.municipalities) {
            if (municipality.name.toLowerCase() == entry.city.toLowerCase()) {
              _municipality = municipality;
              if (municipality.barangays.any(
                (b) => b.toLowerCase() == entry.barangay.toLowerCase(),
              )) {
                _barangay = municipality.barangays.firstWhere(
                  (b) => b.toLowerCase() == entry.barangay.toLowerCase(),
                );
              } else {
                _barangay = entry.barangay;
              }
              return;
            }
          }
          return;
        }
      }
    }
    _barangay = entry.barangay.isNotEmpty ? entry.barangay : null;
  }

  void _updateFormState() {
    final isValid = _formKey.currentState?.validate() ?? false;
    final dropdownsValid = VehicleFormConfig.dropdownOptions.keys.every(
      (key) => _dropdownValues[key] != null,
    );
    final locationValid =
        _region != null &&
        _province != null &&
        _municipality != null &&
        _barangay != null;

    bool hasChanges = true;
    if (widget.initialEntry != null) {
      hasChanges =
          _controllers.entries.any(
            (e) => e.value.text != _getFieldValue(e.key, widget.initialEntry!),
          ) ||
          _dropdownValues.entries.any(
            (e) =>
                e.value !=
                _getValidDropdownValue(
                  e.key,
                  _getFieldValue(e.key, widget.initialEntry!),
                ),
          ) ||
          _barangay != widget.initialEntry!.barangay ||
          (_province?.name ?? '') != widget.initialEntry!.province ||
          (_municipality?.name ?? '') != widget.initialEntry!.city;
    }

    setState(() {
      _isFormValid = isValid && dropdownsValid && locationValid;
      _hasChanges = hasChanges;
    });
  }

  Widget _buildFieldWidget(String fieldKey, String label) {
    if (VehicleFormConfig.dropdownOptions.containsKey(fieldKey)) {
      return CustomDropdownField<String>(
        value: _dropdownValues[fieldKey],
        items: VehicleFormConfig.dropdownOptions[fieldKey]!,
        hintText: label,
        onChanged: (value) {
          setState(() {
            _dropdownValues[fieldKey] = value;
            _updateFormState();
          });
        },
      );
    }

    return CustomTextField(
      labelText: label,
      controller: _controllers[fieldKey]!,
      validator: (val) => FormValidator.validateRequired(val, label),
      onChanged: (_) => _updateFormState(),
    );
  }

  Widget _buildLocationFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRegionDropdown(
          value: _region,
          labelText: 'Region',
          onChanged: (Region? value) {
            setState(() {
              if (_region != value) {
                _province = null;
                _municipality = null;
                _barangay = null;
              }
              _region = value;
              _updateFormState();
            });
          },
          validator: (value) => value == null ? 'Region is required' : null,
        ),
        Spacing.vertical(size: AppIconSizes.medium),
        Row(
          children: [
            Expanded(
              child: CustomProvinceDropdown(
                value: _province,
                provinces: _region?.provinces ?? [],
                labelText: 'Province',
                onChanged: (Province? value) {
                  setState(() {
                    if (_province != value) {
                      _municipality = null;
                      _barangay = null;
                    }
                    _province = value;
                    _updateFormState();
                  });
                },
                validator:
                    (value) => value == null ? 'Province is required' : null,
              ),
            ),
            Spacing.horizontal(size: AppIconSizes.medium),
            Expanded(
              child: CustomMunicipalityDropdown(
                value: _municipality,
                municipalities: _province?.municipalities ?? [],
                labelText: 'City/Municipality',
                onChanged: (Municipality? value) {
                  setState(() {
                    if (_municipality != value) {
                      _barangay = null;
                    }
                    _municipality = value;
                    _updateFormState();
                  });
                },
                validator:
                    (value) =>
                        value == null ? 'City/Municipality is required' : null,
              ),
            ),
          ],
        ),
        Spacing.vertical(size: AppIconSizes.medium),
        CustomBarangayDropdown(
          value: _barangay,
          barangays: _municipality?.barangays ?? [],
          labelText: 'Barangay',
          onChanged: (String? value) {
            setState(() {
              _barangay = value;
              _updateFormState();
            });
          },
          validator:
              (value) =>
                  value == null || value.isEmpty
                      ? 'Barangay is required'
                      : null,
        ),
        Spacing.vertical(size: AppIconSizes.medium),
        CustomTextField(
          labelText: 'Purok',
          controller: _controllers["purok"]!,
          validator: (val) => FormValidator.validateRequired(val, 'Purok'),
          onChanged: (_) => _updateFormState(),
        ),
      ],
    );
  }

  VehicleEntry _buildVehicleEntry() {
    return VehicleEntry(
      vehicleId: widget.initialEntry?.vehicleId ?? '',
      ownerName: _controllers["ownerName"]!.text,
      schoolID: _controllers["schoolID"]!.text,
      department: _dropdownValues["department"] ?? '',
      plateNumber: _controllers["plateNumber"]!.text,
      vehicleType: _dropdownValues["vehicleType"] ?? 'two-wheeled',
      vehicleModel: _controllers["vehicleModel"]!.text,
      vehicleColor: _dropdownValues["vehicleColor"] ?? '',
      licenseNumber: _controllers["licenseNumber"]!.text,
      orNumber: _controllers["orNumber"]!.text,
      crNumber: _controllers["crNumber"]!.text,

      gender: _dropdownValues["gender"] ?? '',
      yearLevel: _dropdownValues["yearLevel"] ?? '',
      block: _dropdownValues["block"] ?? '',
      contact: _controllers["contact"]!.text,
      purok: _controllers["purok"]!.text,
      barangay: LocationFormatter().toProperCase(_barangay ?? ''),
      city: LocationFormatter().toProperCase(_municipality?.name ?? ''),
      province: LocationFormatter().toProperCase(_province?.name ?? ''),
      createdAt: widget.initialEntry?.createdAt ?? Timestamp.now(),
      academicYear: _dropdownValues["academicYear"] ?? '',
      semester: _dropdownValues["semester"] ?? '',
    );
  }

  void _handleSave(BuildContext context) {
    if (!_formKey.currentState!.validate() ||
        _region == null ||
        _province == null ||
        _municipality == null ||
        _barangay == null ||
        !_dropdownValues.values.every(
          (value) => value != null && value.isNotEmpty,
        )) {
      return;
    }

    final entry = _buildVehicleEntry();
    widget.onSave(entry);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) {
      controller.removeListener(_updateFormState);
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return CustomDialog(
      icon: PhosphorIconsBold.motorcycle,
      btnTxt: widget.initialEntry == null ? 'Save' : 'Update',
      onSubmit:
          //_hasChanges ? () => _handleSave(context) : null,
          //_isFormValid ? () => _handleSave(context) : null,
          _isFormValid && _hasChanges ? () => _handleSave(context) : null,
      // () {
      //   _handleSave(context);
      // },
      title: widget.title,
      height: screenHeight * 0.9,
      width: screenWidth * 0.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          onChanged: _updateFormState,
          child: Column(
            children: [
              Spacing.vertical(size: AppSpacing.small),
              for (var pair in VehicleFormConfig.fieldLayout) ...[
                Row(
                  children: [
                    Expanded(
                      child: _buildFieldWidget(
                        pair[0],
                        VehicleFormConfig.fieldLabels[pair[0]]!,
                      ),
                    ),
                    if (pair.length > 1 && pair[1].isNotEmpty) ...[
                      Spacing.horizontal(size: AppIconSizes.medium),
                      Expanded(
                        child: _buildFieldWidget(
                          pair[1],
                          VehicleFormConfig.fieldLabels[pair[1]]!,
                        ),
                      ),
                    ],
                    if (pair.length > 2 && pair[2].isNotEmpty) ...[
                      Spacing.horizontal(size: AppIconSizes.medium),
                      Expanded(
                        child: _buildFieldWidget(
                          pair[2],
                          VehicleFormConfig.fieldLabels[pair[2]]!,
                        ),
                      ),
                    ],
                  ],
                ),
                Spacing.vertical(size: AppIconSizes.medium),
              ],
              _buildLocationFields(),
              Spacing.vertical(size: AppIconSizes.medium),
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
      ),
    );
  }
}
