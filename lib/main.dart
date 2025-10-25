import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'main.dart';
import 'screens/login_screen.dart';
import 'screens/admin_home_screen.dart';
import 'screens/events_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/home_screen.dart';
import 'providers/theme_provider.dart';
import 'models/event_model.dart';
import 'widgets/floating_chat_button.dart';

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

// Global key for navigator
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class KIITPortalApp extends ConsumerWidget {
  const KIITPortalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider) == AppTheme.dark;

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'KIIT',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      // Builder to add floating chat button overlay to all screens
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
            const FloatingChatButton(),
          ],
        );
      },
      // Bypass login for testing - change this to the screen you want to test
      home: const HomeScreen(rollNumber: '22052611'), // Change back to LoginScreen() for production
      onGenerateRoute: (settings) {
        final args = settings.arguments;

        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (_) => const AdminHomeScreen());

          case '/events':
            if (args is String) {
              return MaterialPageRoute(
                builder: (_) => EventsScreen(rollNumber: args),
              );
            } else if (args is Map<String, dynamic> &&
                args['rollNumber'] is String) {
              return MaterialPageRoute(
                builder: (_) =>
                    EventsScreen(rollNumber: args['rollNumber']),
              );
            } else {
              return _errorRoute("Missing or invalid roll number.");
            }

          case '/event-detail':
            if (args is Event) {
              return MaterialPageRoute(
                  builder: (_) => EventDetailScreen(event: args));
            } else if (args is Map<String, dynamic>) {
              return MaterialPageRoute(
                builder: (_) => EventDetailScreen(event: _parseEvent(args)),
              );
            } else {
              return _errorRoute("Invalid event data.");
            }

          default:
            return _errorRoute("Page not found.");
        }
      },
    );
  }

  static Route _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text(message, style: const TextStyle(fontSize: 18))),
      ),
    );
  }

  static Event _parseEvent(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Untitled Event',
      date: _parseDate(map['date']),
      category: map['category'] ?? 'General',
      icon: _parseIcon(map['icon']),
      color: _parseColor(map['color']),
      location: map['location'] ?? 'TBD',
      description: map['description'] ?? 'No description',
    );
  }

  static DateTime _parseDate(dynamic date) {
    if (date is DateTime) return date;
    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (_) {}
    }
    return DateTime.now();
  }

  static IconData _parseIcon(dynamic icon) {
    if (icon is IconData) return icon;
    if (icon is String) {
      switch (icon) {
        case 'event':
          return Icons.event;
        case 'school':
          return Icons.school;
        case 'sports':
          return Icons.sports;
        case 'celebration':
          return Icons.celebration;
        case 'code':
          return Icons.code;
        default:
          return Icons.event;
      }
    }
    return Icons.event;
  }

  static Color _parseColor(dynamic color) {
    if (color is Color) return color;
    if (color is int) return Color(color);
    if (color is String) {
      try {
        return Color(int.parse(color.replaceFirst('#', '0xff')));
      } catch (_) {}
    }
    return Colors.blue;
  }
}
