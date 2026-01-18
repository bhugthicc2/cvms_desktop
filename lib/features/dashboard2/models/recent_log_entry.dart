import 'package:equatable/equatable.dart';

class RecentLogEntry extends Equatable {
  final String logId;
  final DateTime timeIn;
  final DateTime? timeOut;
  final int? durationMinutes;
  final String status;
  final String updatedBy;

  const RecentLogEntry({
    required this.logId,
    required this.timeIn,
    this.timeOut,
    this.durationMinutes,
    required this.status,
    required this.updatedBy,
  });

  // Computed properties
  bool get isActive => status.toLowerCase() == 'onsite';
  bool get isCompleted => status.toLowerCase() == 'offsite';
  bool get hasTimeOut => timeOut != null;
  bool get hasDuration => durationMinutes != null;

  @override
  List<Object?> get props => [
    logId,
    timeIn,
    timeOut,
    durationMinutes,
    status,
    updatedBy,
  ];
}
