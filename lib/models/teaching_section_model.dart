class TeachingSection {
  final String sectionId;
  final String sectionName;
  final String courseName;
  final String courseId;

  TeachingSection({
    required this.sectionId,
    required this.sectionName,
    required this.courseId,
    required this.courseName,
  });

  String get uniqueId => '$sectionId-$courseId';

  String get displayName => '$sectionName - $courseName';

  factory TeachingSection.fromJson(Map<String, dynamic> json) {
    return TeachingSection(
      sectionId: json['section_id'],
      sectionName: json['section_name'],
      courseId: json['course_id'],
      courseName: json['course_name'],
    );
  }
}
