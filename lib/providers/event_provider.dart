import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventNotifier extends ChangeNotifier {
  List<Event> _events = _demoEvents;

  List<Event> get events => _events;

  static final List<Event> _demoEvents = [
    Event(
      id: '1',
      name: "TedXKIIT",
      date: DateTime(2025, 4, 5),
      category: "Conference",
      icon: Icons.mic,
      color: Colors.orange,
      location: "Campus Auditorium",
      description: "Annual TEDx event featuring inspiring speakers from various fields.",
    ),
    Event(
      id: '2',
      name: "KIIT MUN",
      date: DateTime(2025, 8, 20),
      category: "Conference",
      icon: Icons.public,
      color: Colors.blue,
      location: "Seminar Hall",
      description: "Model United Nations conference for students.",
    ),
  ];
}

class BookmarkNotifier extends ChangeNotifier {
  List<String> _bookmarkedIds = [];

  List<String> get bookmarkedIds => _bookmarkedIds;

  void toggleBookmark(String eventId) {
    if (_bookmarkedIds.contains(eventId)) {
      _bookmarkedIds = _bookmarkedIds.where((id) => id != eventId).toList();
    } else {
      _bookmarkedIds = [..._bookmarkedIds, eventId];
    }
    notifyListeners();
  }
}