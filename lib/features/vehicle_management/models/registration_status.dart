enum RegistrationStatus { active, suspended, expired, revoked }

extension RegistrationStatusX on RegistrationStatus {
  String get value => name;

  static RegistrationStatus fromString(String? value) {
    return RegistrationStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => RegistrationStatus.active,
    );
  }
}
