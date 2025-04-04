import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/login_screen.dart';
import 'screens/admin_home_screen.dart'; // Fixed import
import 'screens/events_screen.dart';
import 'screens/event_detail_screen.dart';
import 'providers/theme_provider.dart';
import 'models/event_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD8Nbfh07E3J1uU_9q8xUKcaLYZppASXxY",
      authDomain: "kiit-portal-app.firebaseapp.com",
      projectId: "kiit-portal-app",
      storageBucket: "kiit-portal-app.appspot.com",
      messagingSenderId: "1234567890",
      appId: "1:1234567890:web:abc123def456",
    ),
  );

  runApp(const ProviderScope(child: KIITPortalApp()));
}

class KIITPortalApp extends ConsumerWidget {
  const KIITPortalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      themeMode: ref.watch(themeProvider) == AppTheme.dark ? ThemeMode.dark : ThemeMode.light,
      home: LoginScreen(),
      routes: {
        '/home': (context) => AdminHomeScreen(),
        '/events': (context) => EventsScreen(),
        '/event-detail': (context) {
          final eventArgs = ModalRoute.of(context)!.settings.arguments;
          if (eventArgs is Event) {
            return EventDetailScreen(event: eventArgs);
          } else if (eventArgs is Map<String, dynamic>) {
            // Convert manually in case the type is map
            final event = Event(
              id: eventArgs['id'] ?? '',
              name: eventArgs['name'] ?? '',
              date: _parseDate(eventArgs['date']),
              category: eventArgs['category'] ?? '',
              icon: _parseIcon(eventArgs['icon']),
              color: _parseColor(eventArgs['color']),
              location: eventArgs['location'] ?? '',
              description: eventArgs['description'],
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
    return Icons.event;
  }

  static Color _parseColor(dynamic color) {
    if (color is Color) return color;
    return Colors.blue;
  }
}
