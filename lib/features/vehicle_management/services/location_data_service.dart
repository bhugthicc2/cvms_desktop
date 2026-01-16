import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown2.dart';
import 'package:philippines_rpcmb/philippines_rpcmb.dart';

class LocationDataService {
  static Region? getRegionById(String? regionId) {
    if (regionId == null) return null;
    try {
      return philippineRegions.firstWhere((r) => r.id == regionId);
    } catch (e) {
      return null;
    }
  }

  static Province? getProvinceByName(Region? region, String? provinceName) {
    if (region == null || provinceName == null) return null;
    try {
      return region.provinces.firstWhere((p) => p.name == provinceName);
    } catch (e) {
      return null;
    }
  }

  static Municipality? getMunicipalityByName(
    Province? province,
    String? municipalityName,
  ) {
    if (province == null || municipalityName == null) return null;
    try {
      return province.municipalities.firstWhere(
        (m) => m.name == municipalityName,
      );
    } catch (e) {
      return null;
    }
  }

  static List<CustDropdownMenuItem<String>> buildRegionItems() {
    return philippineRegions
        .map(
          (region) => CustDropdownMenuItem<String>(
            value: region.id,
            child: Text(region.id),
          ),
        )
        .toList();
  }

  static List<CustDropdownMenuItem<String>> buildProvinceItems(Region? region) {
    if (region == null) return [];
    return region.provinces
        .map(
          (province) => CustDropdownMenuItem<String>(
            value: province.name,
            child: Text(province.name),
          ),
        )
        .toList();
  }

  static List<CustDropdownMenuItem<String>> buildMunicipalityItems(
    Province? province,
  ) {
    if (province == null) return [];
    return province.municipalities
        .map(
          (municipality) => CustDropdownMenuItem<String>(
            value: municipality.name,
            child: Text(municipality.name),
          ),
        )
        .toList();
  }

  static List<CustDropdownMenuItem<String>> buildBarangayItems(
    Municipality? municipality,
  ) {
    if (municipality == null) return [];
    return municipality.barangays
        .map(
          (barangay) => CustDropdownMenuItem<String>(
            value: barangay,
            child: Text(barangay),
          ),
        )
        .toList();
  }
}
