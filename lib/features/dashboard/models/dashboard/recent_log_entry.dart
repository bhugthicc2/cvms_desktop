import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Factory constructor for creating from Firestore data
  factory RecentLogEntry.fromFirestore(String id, Map<String, dynamic> data) {
    return RecentLogEntry(
      logId: id,
      timeIn: (data['timeIn'] as Timestamp).toDate(),
      timeOut:
          data['timeOut'] != null
              ? (data['timeOut'] as Timestamp).toDate()
              : null,
      durationMinutes: data['durationMinutes'] as int?,
      status: data['status'] as String? ?? '',
      updatedBy: data['updatedByUserId'] as String? ?? '',
    );
  }

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
