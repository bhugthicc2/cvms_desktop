enum ViolationStatus {
  pending, // reported, not yet reviewed
  confirmed, // admin confirmed the violation
  dismissed, // admin rejected / invalid
  sanctioned, // sanction has been applied
}

extension ViolationStatusX on ViolationStatus {
  String get value => name;

  String get label {
    switch (this) {
      case ViolationStatus.pending:
        return 'Pending Review';
      case ViolationStatus.confirmed:
        return 'Confirmed';
      case ViolationStatus.dismissed:
        return 'Dismissed';
      case ViolationStatus.sanctioned:
        return 'Sanction Applied';
    }
  }
}
