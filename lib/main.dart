import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/app_config.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'services/api_service.dart';
import 'widgets/floating_chat_button.dart';
import 'screens/splash_wrapper.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/enrollment/enrollment_screen.dart';
import 'screens/shell/main_app_shell.dart';
import 'screens/notices/notices_screen.dart';
import 'screens/notices/create_notice_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/grades_screen.dart';
import 'screens/student/student_fees_screen.dart';
import 'screens/teacher/teacher_profile_screen.dart';
import 'screens/chatbot/ai_chat_screen.dart';
import 'screens/resume_reviewer_screen.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use clean URLs on web (no #)
  setUrlStrategy(PathUrlStrategy());

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase (Auth & Realtime only)
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  runApp(const KIITPortalApp());
}

class KIITPortalApp extends StatelessWidget {
  const KIITPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create ApiService instance
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        // Provide ApiService
        Provider<ApiService>.value(value: apiService),
        // Provide ThemeNotifier
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(),
        ),
        // Provide AuthProvider with Supabase client and ApiService
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            Supabase.instance.client,
            apiService,
          ),
        ),
        // Provide FloatingButtonPositionNotifier
        ChangeNotifierProvider<FloatingButtonPositionNotifier>(
          create: (_) => FloatingButtonPositionNotifier(),
        ),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'KIIT SAP Portal',
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: themeNotifier.theme == AppTheme.dark
                ? ThemeMode.dark
                : ThemeMode.light,
            // Routes
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashWrapper(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignUpScreen(),
              '/enroll': (context) => const EnrollmentScreen(),
              '/home': (context) => const MainAppShell(),
              '/grades': (context) => const GradesScreen(),
              '/fees': (context) => const StudentFeesScreen(),
              '/profile': (context) => const TeacherProfileScreen(),
              '/notices': (context) => const NoticesScreen(),
              '/create-notice': (context) => const CreateNoticeScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/ai-chat': (context) => const AiChatScreen(),
              '/resume-review': (context) => const ResumeReviewerScreen(),
            },
          );
        },
      ),
    );
  }
}

