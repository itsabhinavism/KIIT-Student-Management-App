import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/app_config.dart';
import 'providers/auth_provider.dart';
import 'services/api_service.dart';
import 'screens/splash_wrapper.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/enrollment/enrollment_screen.dart';
import 'screens/shell/main_app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        // Provide AuthProvider with Supabase client and ApiService
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            Supabase.instance.client,
            apiService,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KIIT SAP Portal',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        // Routes
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashWrapper(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/enroll': (context) => const EnrollmentScreen(),
          '/home': (context) => const MainAppShell(),
        },
      ),
    );
  }
}
