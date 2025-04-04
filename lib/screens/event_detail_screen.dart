import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareEvent(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'event-${event.id}',
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: event.color.withOpacity(0.1),
                ),
                alignment: Alignment.center,
                child: Icon(event.icon, size: 80, color: event.color),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              event.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(event.formattedDate),
                const SizedBox(width: 16),
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(event.location),
              ],
            ),
            const SizedBox(height: 24),
            Chip(
              label: Text(event.category),
              backgroundColor: event.color.withOpacity(0.1),
              labelStyle: TextStyle(color: event.color),
            ),
            const SizedBox(height: 24),
            Text(
              'About this event',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              event.description ?? 'No description available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.how_to_reg),
                label: const Text('Register Now'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: event.color,
                ),
                onPressed: () => _registerForEvent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareEvent(BuildContext context) {
 
  }

  void _registerForEvent(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register for Event'),
        content: Text('Register for ${event.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registered for ${event.name}')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
