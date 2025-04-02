import 'package:flutter/material.dart';

class Event {
  final String id;
  final String name;
  final DateTime date;
  final String category;
  final IconData icon;
  final Color color;
  final String? description;
  final String location;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.category,
    required this.icon,
    required this.color,
    this.description,
    required this.location,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      date: _parseDate(map['date']),
      category: map['category'] ?? '',
      icon: _parseIcon(map['icon']),
      color: _parseColor(map['color']),
      description: map['description'],
      location: map['location'] ?? '',
    );
  }

  String get formattedDate => '${date.day} ${_monthNames[date.month - 1]} ${date.year}';

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  static DateTime _parseDate(dynamic date) {
    if (date is DateTime) return date;
    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  static IconData _parseIcon(dynamic icon) {
    if (icon is IconData) return icon;
    return Icons.event;
  }

  static Color _parseColor(dynamic color) {
    if (color is Color) return color;
    return Colors.blue;
  }
}
