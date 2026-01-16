class AddressState {
  String? selectedRegionId;
  String? selectedProvinceName;
  String? selectedMunicipalityName;
  String? selectedBarangay;
  String purokStreet;

  AddressState({
    this.selectedRegionId,
    this.selectedProvinceName,
    this.selectedMunicipalityName,
    this.selectedBarangay,
    this.purokStreet = '',
  });

  AddressState copyWith({
    String? selectedRegionId,
    String? selectedProvinceName,
    String? selectedMunicipalityName,
    String? selectedBarangay,
    String? purokStreet,
  }) {
    return AddressState(
      selectedRegionId: selectedRegionId ?? this.selectedRegionId,
      selectedProvinceName: selectedProvinceName ?? this.selectedProvinceName,
      selectedMunicipalityName:
          selectedMunicipalityName ?? this.selectedMunicipalityName,
      selectedBarangay: selectedBarangay ?? this.selectedBarangay,
      purokStreet: purokStreet ?? this.purokStreet,
    );
  }

  void resetDependentFields() {
    selectedProvinceName = null;
    selectedMunicipalityName = null;
    selectedBarangay = null;
  }

  void resetMunicipalityAndBarangay() {
    selectedMunicipalityName = null;
    selectedBarangay = null;
  }

  void resetBarangay() {
    selectedBarangay = null;
  }
}
