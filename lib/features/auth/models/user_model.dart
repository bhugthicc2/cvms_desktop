class UserModel {
  final String id;
  final String email;
  final String name;
  final String fullname;
  final String role;
  final String status;
  final DateTime? lastLogin;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.fullname,
    required this.role,
    required this.status,
    this.lastLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      fullname: json['fullname'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? 'active',
      lastLogin:
          json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'fullname': fullname,
    'role': role,
    'status': status,
  };
}
