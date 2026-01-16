import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown2.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class LocationDropdowns extends StatelessWidget {
  final List<CustDropdownMenuItem<String>> regionItems;
  final List<CustDropdownMenuItem<String>> provinceItems;
  final List<CustDropdownMenuItem<String>> municipalityItems;
  final List<CustDropdownMenuItem<String>> barangayItems;
  final String? selectedRegionId;
  final String? selectedProvinceName;
  final String? selectedMunicipalityName;
  final String? selectedBarangay;
  final ValueChanged<String?> onRegionChanged;
  final ValueChanged<String?> onProvinceChanged;
  final ValueChanged<String?> onMunicipalityChanged;
  final ValueChanged<String?> onBarangayChanged;

  const LocationDropdowns({
    super.key,
    required this.regionItems,
    required this.provinceItems,
    required this.municipalityItems,
    required this.barangayItems,
    this.selectedRegionId,
    this.selectedProvinceName,
    this.selectedMunicipalityName,
    this.selectedBarangay,
    required this.onRegionChanged,
    required this.onProvinceChanged,
    required this.onMunicipalityChanged,
    required this.onBarangayChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: Region & Province
        Row(
          children: [
            Expanded(
              child: CustDropDown<String>(
                hintText: "Region",
                items: regionItems,
                onChanged: onRegionChanged,
              ),
            ),
            const Spacing.horizontal(size: AppSpacing.large),
            Expanded(
              child: CustDropDown<String>(
                hintText: "Province",
                items: provinceItems,
                onChanged: onProvinceChanged,
              ),
            ),
          ],
        ),
        const Spacing.vertical(size: AppSpacing.medium),
        // Row 2: Municipality & Barangay
        Row(
          children: [
            Expanded(
              child: CustDropDown<String>(
                hintText: "Municipality",
                items: municipalityItems,
                onChanged: onMunicipalityChanged,
              ),
            ),
            const Spacing.horizontal(size: AppSpacing.large),
            Expanded(
              child: CustDropDown<String>(
                hintText: "Barangay",
                items: barangayItems,
                onChanged: onBarangayChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
