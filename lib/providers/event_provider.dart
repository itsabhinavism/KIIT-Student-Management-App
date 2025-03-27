import 'package:flutter/material.dart'; // Add this import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model.dart';

final eventProvider = StateNotifierProvider<EventNotifier, List<Event>>((ref) {
  return EventNotifier();
});

final bookmarkedEventsProvider = StateNotifierProvider<BookmarkNotifier, List<String>>((ref) {
  return BookmarkNotifier();
});

class EventNotifier extends StateNotifier<List<Event>> {
  EventNotifier() : super(_demoEvents);

  static final List<Event> _demoEvents = [
    Event(
      id: '1',
      name: "TedXKIIT",
      date: DateTime(2025, 4, 5),
      category: "Conference",
      icon: Icons.mic, // Now recognized
      color: Colors.orange, // Now recognized
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
    // Add more events as needed
  ];
}

class BookmarkNotifier extends StateNotifier<List<String>> {
  BookmarkNotifier() : super([]);

  void toggleBookmark(String eventId) {
    state = state.contains(eventId)
        ? state.where((id) => id != eventId).toList()
        : [...state, eventId];
  }
}