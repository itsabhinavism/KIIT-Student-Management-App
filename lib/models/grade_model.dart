class Grade {
  final int semester;
  final double sgpa;
  final String letterGrade;
  final String courseName;
  final String courseCode;

  Grade({
    required this.semester,
    required this.sgpa,
    required this.letterGrade,
    required this.courseName,
    required this.courseCode,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      semester: json['semester'] ?? 0,
      sgpa: (json['sgpa'] ?? 0).toDouble(),
      letterGrade: json['letter_grade'] ?? '',
      courseName: json['courses']?['course_name'] ?? '',
      courseCode: json['courses']?['course_code'] ?? '',
    );
  }
}
