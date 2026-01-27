enum VehicleRegistrationStatus { active, suspended, revoked }

extension VehicleRegistrationStatusX on VehicleRegistrationStatus {
  String get label {
    switch (this) {
      case VehicleRegistrationStatus.active:
        return 'Active';
      case VehicleRegistrationStatus.suspended:
        return 'Suspended';
      case VehicleRegistrationStatus.revoked:
        return 'Revoked';
    }
  }
}
