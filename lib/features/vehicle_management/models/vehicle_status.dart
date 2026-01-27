enum VehicleStatus { active, suspended, revoked }

extension VehicleStatusValue on VehicleStatus {
  String get value {
    switch (this) {
      case VehicleStatus.active:
        return 'active';
      case VehicleStatus.suspended:
        return 'suspended';
      case VehicleStatus.revoked:
        return 'revoked';
    }
  }

  static VehicleStatus fromValue(String value) {
    return VehicleStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => VehicleStatus.active,
    );
  }
}
