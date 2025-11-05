/// Section model for course enrollment
class Section {
  const Section({
    required this.id,
    required this.sectionName,
    required this.year,
    required this.branch,
    required this.semester,
    required this.seatLimit,
    required this.seatsFilled,
  });

  final String id;
  final String sectionName;
  final int year;
  final String branch;
  final int semester;
  final int seatLimit;
  final int seatsFilled;

  String get displayName => '$branch-$year ($sectionName)';
  String get availableSeats => '${seatLimit - seatsFilled}/$seatLimit seats';

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id']?.toString() ?? '',
      sectionName: json['section_name']?.toString() ?? '',
      year: json['year'] ?? 0,
      branch: json['branch']?.toString() ?? '',
      semester: json['semester'] ?? 0,
      seatLimit: json['seat_limit'] ?? 0,
      seatsFilled: json['seats_filled'] ?? 0,
    );
  }
}
