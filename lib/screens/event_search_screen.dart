import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../widgets/event_card.dart';

class EventSearchDelegate extends SearchDelegate {
  final List<Event> events;

  EventSearchDelegate({required this.events});

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    final results = query.isEmpty
        ? events
        : events.where((e) =>
            e.name.toLowerCase().contains(query.toLowerCase()) ||
            e.category.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) => EventCard(
        event: results[index],
        showBookmark: false,
      ),
    );
  }
}
