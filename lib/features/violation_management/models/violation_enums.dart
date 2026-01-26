enum ViolationStatus { pending, confirmed, dismissed, suspended, revoked }

extension ViolationStatusX on ViolationStatus {
  String get value => name;

  String get label {
    switch (this) {
      case ViolationStatus.pending:
        return 'Pending';
      case ViolationStatus.confirmed:
        return 'Confirmed';
      case ViolationStatus.dismissed:
        return 'Dismissed';
      case ViolationStatus.suspended:
        return 'Suspended';
      case ViolationStatus.revoked:
        return 'Revoked';
    }
  }
}
