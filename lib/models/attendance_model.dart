/// Attendance summary model
class AttendanceSummary {
  const AttendanceSummary({
    required this.courseCode,
    required this.courseName,
    required this.totalClasses,
    required this.attendedClasses,
    required this.percentage,
  });

  final String courseCode;
  final String courseName;
  final int totalClasses;
  final int attendedClasses;
  final double percentage;

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      courseCode: json['course_code']?.toString() ??
          json['courseCode']?.toString() ??
          '',
      courseName: json['course_name']?.toString() ??
          json['courseName']?.toString() ??
          '',
      totalClasses: _parseInt(json['total_sessions'] ?? 0),
      attendedClasses: _parseInt(json['attended_count'] ?? 0),
      percentage: _parseDouble(json['percentage']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
