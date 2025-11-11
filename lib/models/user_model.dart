/// User model representing authenticated user data from API
class User {
  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.rollNo,
    this.avatarUrl,
    this.currentSemester,
    this.enrolledSections,
  });

  final String id;
  final String email;
  final String fullName;
  final String role; // 'student' or 'teacher'
  final String? rollNo;
  String? avatarUrl;
  final int? currentSemester;
  final String? enrolledSections;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName:
          json['full_name']?.toString() ?? json['fullName']?.toString() ?? '',
      role: json['role']?.toString() ?? 'student',
      rollNo: json['roll_no']?.toString() ?? json['rollNo']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
      currentSemester: json['current_semester'] as int?,
      enrolledSections: json['enrolled_sections']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role,
      if (rollNo != null) 'roll_no': rollNo,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (currentSemester != null) 'current_semester': currentSemester,
      if (enrolledSections != null) 'enrolled_sections': enrolledSections,
    };
  }
}
