enum SanctionType { warning, suspension, revocation }

enum SanctionStatus { active, expired, revoked }

extension SanctionTypeX on SanctionType {
  String get value => name;

  static SanctionType fromValue(String value) =>
      SanctionType.values.byName(value);
}

extension SanctionStatusX on SanctionStatus {
  String get value => name;

  static SanctionStatus fromValue(String value) =>
      SanctionStatus.values.byName(value);
}
