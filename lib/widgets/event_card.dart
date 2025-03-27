import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';
import '../screens/event_detail_screen.dart'; // Import for navigation

class EventCard extends ConsumerWidget {
  final Event event;
  final bool showBookmark;

  const EventCard({
    super.key,
    required this.event,
    this.showBookmark = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked = ref.watch(bookmarkedEventsProvider).contains(event.id);
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToDetail(context, event),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon Container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: event.color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      event.icon, 
                      color: event.color, 
                      size: 28
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Event Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${event.formattedDate} • ${event.location}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  // Bookmark Button
                  if (showBookmark) 
                    IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? event.color : null,
                      ),
                      onPressed: () => ref
                          .read(bookmarkedEventsProvider.notifier)
                          .toggleBookmark(event.id),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Category Chip
              Chip(
                label: Text(event.category),
                backgroundColor: event.color.withOpacity(0.1),
                labelStyle: TextStyle(color: event.color),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(event: event),
      ),
    );
  }
}