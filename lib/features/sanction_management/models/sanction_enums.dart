enum SanctionType { warning, suspension, revocation }

enum SanctionStatus { active, expired }

extension SanctionTypeX on SanctionType {
  String get label {
    switch (this) {
      case SanctionType.warning:
        return 'Written Warning';
      case SanctionType.suspension:
        return '30-Day Suspension';
      case SanctionType.revocation:
        return 'MVP Revocation';
    }
  }
}

extension SanctionStatusX on SanctionStatus {
  String get label {
    switch (this) {
      case SanctionStatus.active:
        return 'Active';
      case SanctionStatus.expired:
        return 'Expired';
    }
  }
}
