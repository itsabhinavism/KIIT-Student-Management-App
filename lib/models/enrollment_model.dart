import 'section_model.dart';

/// Enrollment model representing a student's enrollment in a section
class Enrollment {
  const Enrollment({
    required this.id,
    required this.section,
    required this.enrolledAt,
  });

  final String id;
  final Section section;
  final DateTime enrolledAt;

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id']?.toString() ?? '',
      section: Section.fromJson(json['section'] as Map<String, dynamic>? ?? {}),
      enrolledAt: DateTime.tryParse(json['enrolled_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
