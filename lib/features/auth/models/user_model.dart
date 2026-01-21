//CURRENTLY NOT USED

class UserModel {
  final String id;
  final String email;
  final String fullname;
  final String role;
  final String status;
  final DateTime? lastLogin;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.email,
    required this.fullname,
    required this.role,
    required this.status,
    this.lastLogin,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullname: json['fullname'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? 'active',
      lastLogin:
          json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'fullname': fullname,
    'role': role,
    'status': status,
    'profileImage': profileImage,
  };
}
