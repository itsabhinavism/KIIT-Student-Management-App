/// Configuration constants for the KIIT SAP Portal app
class AppConfig {
  AppConfig._();

  // Supabase Configuration (Auth & Realtime only)
  static const String supabaseUrl = 'https://chjhlmffmvloljmzektv.supabase.co';
  static const String supabaseAnonKey =
      'sb_publishable_O01D_N5Fyrdb1Tjyo2nZtw_HfMBQ7yl';

  // Hono.js Backend API Base URL (All business logic)
  static const String apiBaseUrl = 'https://testing.ashishpothal.live/api/v1';
  // For production, use: 'https://your-production-domain.com/api'
}
