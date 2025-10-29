/// Section model for course enrollment
class Section {
  const Section({
    required this.id,
    required this.code,
    required this.name,
    required this.instructorName,
    this.schedule,
  });

  final String id;
  final String code;
  final String name;
  final String instructorName;
  final String? schedule;

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      instructorName: json['instructor_name']?.toString() ??
          json['instructorName']?.toString() ??
          '',
      schedule: json['schedule']?.toString(),
    );
  }
}
