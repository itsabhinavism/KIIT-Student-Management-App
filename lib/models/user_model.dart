/// User model representing authenticated user data from API
class User {
  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.rollNo,
  });

  final String id;
  final String email;
  final String fullName;
  final String role; // 'student' or 'teacher'
  final String? rollNo;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName:
          json['full_name']?.toString() ?? json['fullName']?.toString() ?? '',
      role: json['role']?.toString() ?? 'student',
      rollNo: json['roll_no']?.toString() ?? json['rollNo']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role,
      if (rollNo != null) 'roll_no': rollNo,
    };
  }
}
