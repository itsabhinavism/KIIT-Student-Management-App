/// Course model representing a student's enrolled course
class Course {
  const Course({
    required this.id,
    required this.name,
    required this.code,
  });

  final String id;
  final String name;
  final String code;

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['course_id']?.toString() ?? '',
      name: json['course_name']?.toString() ?? '',
      code: json['course_code']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_id': id,
      'course_name': name,
      'course_code': code,
    };
  }
}
