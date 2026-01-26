part of 'add_violation_cubit.dart';

class AddViolationState {
  final String? vehicleId;
  final String? reportedByUserId;
  final String? violationType;
  final String status;
  final bool isSubmitting;
  final String? message;
  final SnackBarType? messageType;

  AddViolationState({
    this.vehicleId,
    this.reportedByUserId,
    this.violationType,
    this.status = 'pending',
    this.isSubmitting = false,
    this.message,
    this.messageType,
  });

  factory AddViolationState.initial() {
    return AddViolationState(status: 'pending');
  }

  bool get isFormValid {
    return vehicleId != null &&
        vehicleId!.isNotEmpty &&
        reportedByUserId != null &&
        reportedByUserId!.isNotEmpty &&
        violationType != null &&
        violationType!.isNotEmpty;
  }

  AddViolationState copyWith({
    String? vehicleId,
    String? reportedByUserId,
    String? violationType,
    String? status,
    bool? isSubmitting,
    String? message,
    SnackBarType? messageType,
  }) {
    return AddViolationState(
      vehicleId: vehicleId ?? this.vehicleId,
      reportedByUserId: reportedByUserId ?? this.reportedByUserId,
      violationType: violationType ?? this.violationType,
      status: status ?? this.status,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      message: message ?? this.message,
      messageType: messageType ?? this.messageType,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddViolationState &&
        runtimeType == other.runtimeType &&
        vehicleId == other.vehicleId &&
        reportedByUserId == other.reportedByUserId &&
        violationType == other.violationType &&
        status == other.status &&
        isSubmitting == other.isSubmitting &&
        message == other.message &&
        messageType == other.messageType;
  }

  @override
  int get hashCode {
    return vehicleId.hashCode ^
        reportedByUserId.hashCode ^
        violationType.hashCode ^
        status.hashCode ^
        isSubmitting.hashCode ^
        message.hashCode ^
        messageType.hashCode;
  }
}
