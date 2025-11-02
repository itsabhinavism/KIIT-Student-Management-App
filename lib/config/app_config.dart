import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration constants for the KIIT SAP Portal app
class AppConfig {
  AppConfig._();

  // Supabase Configuration (Auth & Realtime only)
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Hono.js Backend API Base URL (All business logic)
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  // For production, use: 'https://your-production-domain.com/api'
}
