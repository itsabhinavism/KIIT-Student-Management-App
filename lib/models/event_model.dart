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

  String get formattedDate => '${date.day} ${_monthNames[date.month - 1]} ${date.year}';

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
}