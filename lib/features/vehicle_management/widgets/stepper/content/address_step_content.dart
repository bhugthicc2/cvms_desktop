import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown2.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field2.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:philippines_rpcmb/philippines_rpcmb.dart';

class AddressStepContent extends StatefulWidget {
  const AddressStepContent({super.key});

  @override
  State<AddressStepContent> createState() => _AddressStepContentState();
}

class _AddressStepContentState extends State<AddressStepContent> {
  late final TextEditingController _purokController;

  // Location state variables (using String for CustDropDown compatibility)
  String? _selectedRegionId;
  String? _selectedProvinceName;
  String? _selectedMunicipalityName;
  String? _selectedBarangay;

  // Helper objects for data access
  Region? get _selectedRegion => philippineRegions.firstWhere(
    (r) => r.id == _selectedRegionId,
    orElse: () => philippineRegions.first,
  );
  Province? get _selectedProvince => _selectedRegion?.provinces.firstWhere(
    (p) => p.name == _selectedProvinceName,
    orElse: () => _selectedRegion!.provinces.first,
  );
  Municipality? get _selectedMunicipality =>
      _selectedProvince?.municipalities.firstWhere(
        (m) => m.name == _selectedMunicipalityName,
        orElse: () => _selectedProvince!.municipalities.first,
      );

  @override
  void initState() {
    super.initState();
    _purokController = TextEditingController();
  }

  @override
  void dispose() {
    _purokController.dispose();
    super.dispose();
  }

  void _onRegionChanged(String? regionId) {
    setState(() {
      _selectedRegionId = regionId;
      _selectedProvinceName = null;
      _selectedMunicipalityName = null;
      _selectedBarangay = null;
    });
  }

  void _onProvinceChanged(String? provinceName) {
    setState(() {
      _selectedProvinceName = provinceName;
      _selectedMunicipalityName = null;
      _selectedBarangay = null;
    });
  }

  void _onMunicipalityChanged(String? municipalityName) {
    setState(() {
      _selectedMunicipalityName = municipalityName;
      _selectedBarangay = null;
    });
  }

  void _onBarangayChanged(String? barangay) {
    setState(() {
      _selectedBarangay = barangay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxxLarge + 10,
        vertical: AppSpacing.large,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Address',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          Text(
            'Please provide the address details',
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: AppColors.grey,
            ),
          ),
          const Spacing.vertical(size: AppSpacing.large),
          // Row 1: Region & Province
          Row(
            children: [
              Expanded(
                child: CustDropDown<String>(
                  hintText: "Region",
                  items:
                      philippineRegions
                          .map(
                            (region) => CustDropdownMenuItem<String>(
                              value: region.id,
                              child: Text(
                                region.id,
                                style: TextStyle(fontSize: AppFontSizes.small),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: _onRegionChanged,
                ),
              ),
              const Spacing.horizontal(size: AppSpacing.large),
              Expanded(
                child: CustDropDown<String>(
                  hintText: "Province",
                  items:
                      _selectedRegion?.provinces
                          .map(
                            (province) => CustDropdownMenuItem<String>(
                              value: province.name,
                              child: Text(
                                province.name,
                                style: TextStyle(fontSize: AppFontSizes.small),
                              ),
                            ),
                          )
                          .toList() ??
                      [],
                  onChanged: _onProvinceChanged,
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
                  items:
                      _selectedProvince?.municipalities
                          .map(
                            (municipality) => CustDropdownMenuItem<String>(
                              value: municipality.name,
                              child: Text(
                                municipality.name,
                                style: TextStyle(fontSize: AppFontSizes.small),
                              ),
                            ),
                          )
                          .toList() ??
                      [],
                  onChanged: _onMunicipalityChanged,
                ),
              ),
              const Spacing.horizontal(size: AppSpacing.large),
              Expanded(
                child: CustDropDown<String>(
                  hintText: "Barangay",
                  items:
                      _selectedMunicipality?.barangays
                          .map(
                            (barangay) => CustDropdownMenuItem<String>(
                              value: barangay,
                              child: Text(
                                barangay,
                                style: TextStyle(fontSize: AppFontSizes.small),
                              ),
                            ),
                          )
                          .toList() ??
                      [],
                  onChanged: _onBarangayChanged,
                ),
              ),
            ],
          ),
          const Spacing.vertical(size: AppSpacing.medium),
          CustomTextField2(
            label: 'Purok/Street',
            controller: _purokController,
            borderColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
