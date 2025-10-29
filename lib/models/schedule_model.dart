import 'package:intl/intl.dart';

import 'course_model.dart';

/// Schedule item model for timetable
class ScheduleItem {
  const ScheduleItem({
    required this.id,
    required this.course,
    required this.startTime,
    required this.endTime,
    required this.section,
    required this.room,
  });

  final String id;
  final Course course;
  final DateTime startTime;
  final DateTime endTime;
  final Section section;
  final String room;

  static DateTime _parseTime(String timeString) {
    try {
      final now = DateTime.now();
      final parts = timeString.split(':'); // "09:00:00" -> ["09", "00", "00"]

      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]), // Hour
        int.parse(parts[1]), // Minute
        int.parse(parts[2]), // Second
      );
    } catch (e) {
      // Fallback in case parsing fails
      return DateTime.now();
    }
  }

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      id: json['id']?.toString() ?? '',
      course: Course.fromJson(json['courses'] ?? {}),
      section: Section.fromJson(json['sections'] ?? {}),
      startTime: _parseTime(json['start_time']?.toString() ?? '00:00:00'),
      endTime: _parseTime(json['end_time']?.toString() ?? '00:00:00'),
      room: json['room_number']?.toString() ?? '',
    );
  }

  String get formattedStartTime {
    return DateFormat.jm().format(startTime);
  }

  String get formattedEndTime {
    return DateFormat.jm().format(endTime);
  }
}

/// Section model
class Section {
  const Section({
    required this.id,
    required this.year,
    required this.branch,
    required this.sectionName,
  });

  final String id;
  final int year;
  final String branch;
  final String sectionName;

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id']?.toString() ?? '',
      year: json['year'] ?? 0,
      branch: json['branch']?.toString() ?? '',
      sectionName: json['section_name']?.toString() ?? '',
    );
  }
}
