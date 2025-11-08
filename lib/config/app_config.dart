import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration constants for the KIIT SAP Portal app
class AppConfig {
  AppConfig._();

  // Supabase Configuration (Auth & Realtime only)
  static String get supabaseUrl {
    if (kIsWeb) {
      return const String.fromEnvironment('SUPABASE_URL', 
        defaultValue: 'https://chjhlmffmvloljmzektv.supabase.co');
    }
    return dotenv.env['SUPABASE_URL'] ?? '';
  }

  static String get supabaseAnonKey {
    if (kIsWeb) {
      return const String.fromEnvironment('SUPABASE_ANON_KEY',
        defaultValue: 'sb_publishable_O01D_N5Fyrdb1Tjyo2nZtw_HfMBQ7yl');
    }
    return dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  }

  // Hono.js Backend API Base URL (All business logic)
  static String get apiBaseUrl {
    if (kIsWeb) {
      return const String.fromEnvironment('API_BASE_URL',
        defaultValue: 'https://kiit-sma-backend-production.up.railway.app/api/v1');
    }
    return dotenv.env['API_BASE_URL'] ?? '';
  }
}
