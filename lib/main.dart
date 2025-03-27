import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/events_screen.dart';
import 'screens/event_detail_screen.dart';
import 'providers/theme_provider.dart';
import 'models/event_model.dart'; // Add this import

void main() {
  runApp(const ProviderScope(child: KIITPortalApp()));
}

class KIITPortalApp extends ConsumerWidget {
  const KIITPortalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == AppTheme.dark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KIIT Portal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home:  LoginScreen(),
      routes: {
        '/home': (context) =>  HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/events': (context) =>  EventsScreen(),
        '/event-detail': (context) {
          final eventArgs = ModalRoute.of(context)!.settings.arguments;
          
          // Handle both Event object and Map cases
          if (eventArgs is Event) {
            return EventDetailScreen(event: eventArgs);
          } else if (eventArgs is Map<String, dynamic>) {
            // Convert map to Event object
            final event = Event(
              id: eventArgs['id'] ?? '',
              name: eventArgs['name'] ?? '',
              date: _parseDate(eventArgs['date']),
              category: eventArgs['category'] ?? '',
              icon: _parseIcon(eventArgs['icon']),
              color: _parseColor(eventArgs['color']),
              location: eventArgs['location'] ?? '',
              description: eventArgs['description'] ?? '',
            );
            return EventDetailScreen(event: event);
          }
          throw ArgumentError('Invalid event arguments');
        },
      },
    );
  }

  // Helper methods for conversion
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
    if (icon is String) {
      // Add mapping for string icons if needed
      return Icons.event;
    }
    return Icons.event;
  }

  static Color _parseColor(dynamic color) {
    if (color is Color) return color;
    if (color is String) {
      // Add mapping for string colors if needed
      return Colors.blue;
    }
    return Colors.blue;
  }
}
