import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntry {
  final String id;
  final String fullname;
  final String email;
  final String role;
  final String status;
  final DateTime lastLogin;
  final String password;

  const UserEntry({
    required this.id,
    required this.fullname,
    required this.email,
    required this.role,
    required this.status,
    required this.lastLogin,
    required this.password,
  });

  factory UserEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserEntry(
      id: doc.id,
      fullname: data['fullname'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      status: data['status'] ?? '',
      lastLogin: (data['lastLogin'] as Timestamp?)?.toDate() ?? DateTime.now(),
      password: data['password'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullname': fullname,
      'email': email,
      'role': role,
      'status': status,
      'lastLogin': Timestamp.fromDate(lastLogin),
      'password': password,
    };
  }

  UserEntry copyWith({
    String? id,
    String? fullname,
    String? email,
    String? role,
    String? status,
    DateTime? lastLogin,
    String? password,
  }) {
    return UserEntry(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      lastLogin: lastLogin ?? this.lastLogin,
      password: password ?? this.password,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntry && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
