import 'package:cvms_desktop/features/vehicle_management/bloc/address_state.dart';
import 'package:cvms_desktop/features/vehicle_management/services/location_data_service.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown2.dart';
import 'package:philippines_rpcmb/philippines_rpcmb.dart';

class AddressController {
  AddressState _state = AddressState();
  final void Function(AddressState) onStateChanged;

  AddressController({required this.onStateChanged});

  AddressState get state => _state;

  void initializeState(AddressState initialState) {
    _state = initialState;
    onStateChanged(_state);
  }

  void onRegionChanged(String? regionId) {
    _state = _state.copyWith(selectedRegionId: regionId);
    _state.resetDependentFields();
    onStateChanged(_state);
  }

  void onProvinceChanged(String? provinceName) {
    _state = _state.copyWith(selectedProvinceName: provinceName);
    _state.resetMunicipalityAndBarangay();
    onStateChanged(_state);
  }

  void onMunicipalityChanged(String? municipalityName) {
    _state = _state.copyWith(selectedMunicipalityName: municipalityName);
    _state.resetBarangay();
    onStateChanged(_state);
  }

  void onBarangayChanged(String? barangay) {
    _state = _state.copyWith(selectedBarangay: barangay);
    onStateChanged(_state);
  }

  void onPurokStreetChanged(String purokStreet) {
    _state = _state.copyWith(purokStreet: purokStreet);
    onStateChanged(_state);
  }

  // Getters for location data
  Region? get selectedRegion =>
      LocationDataService.getRegionById(_state.selectedRegionId);
  Province? get selectedProvince => LocationDataService.getProvinceByName(
    selectedRegion,
    _state.selectedProvinceName,
  );
  Municipality? get selectedMunicipality =>
      LocationDataService.getMunicipalityByName(
        selectedProvince,
        _state.selectedMunicipalityName,
      );

  // Getters for dropdown items
  List<CustDropdownMenuItem<String>> get regionItems =>
      LocationDataService.buildRegionItems();
  List<CustDropdownMenuItem<String>> get provinceItems =>
      LocationDataService.buildProvinceItems(selectedRegion);
  List<CustDropdownMenuItem<String>> get municipalityItems =>
      LocationDataService.buildMunicipalityItems(selectedProvince);
  List<CustDropdownMenuItem<String>> get barangayItems =>
      LocationDataService.buildBarangayItems(selectedMunicipality);

  void dispose() {
    // Clean up if needed
  }
}
