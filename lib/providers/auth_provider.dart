import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/user_model.dart';
import '../services/api_service.dart';

/// AuthProvider: The "Nervous System" - Single source of truth for authentication state
/// Uses Supabase for Auth, but relies on Hono API for user profile data
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._supabaseClient, this._apiService);

  final SupabaseClient _supabaseClient;
  final ApiService _apiService;

  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  static const String _tokenKey = 'auth_token';

  // Getters
  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null && _user != null;
  ApiService get apiService => _apiService;

  /// Initialize auth state on app startup
  Future<void> initialize() async {
    _setLoading(true);
    try {
      // Try to get existing session
      final session = _supabaseClient.auth.currentSession;
      if (session != null) {
        _token = session.accessToken;
        _apiService.setAuthToken(_token!);
        await _fetchUserProfile();
      } else {
        // Try to restore from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final savedToken = prefs.getString(_tokenKey);
        if (savedToken != null) {
          _token = savedToken;
          _apiService.setAuthToken(_token!);
          await _fetchUserProfile();
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
      await _clearAuth();
    } finally {
      _setLoading(false);
    }
  }

  /// Sign up new user with Supabase
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    String? rollNo,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          if (rollNo != null) 'roll_no': rollNo,
        },
      );

      if (response.session != null) {
        _token = response.session!.accessToken;
        _apiService.setAuthToken(_token!);
        await _saveToken(_token!);
        await _fetchUserProfile();
      } else {
        _errorMessage = 'Please verify your email to continue';
      }
    } on AuthException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Sign in existing user
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        _token = response.session!.accessToken;
        _apiService.setAuthToken(_token!);
        await _saveToken(_token!);
        await _fetchUserProfile();
      }
    } on AuthException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
    await _clearAuth();
    notifyListeners();
  }

  /// Fetch user profile from Hono API
  Future<void> _fetchUserProfile() async {
    try {
      _user = await _apiService.getMyProfile();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch user profile: $e';
      await _clearAuth();
      rethrow;
    }
  }

  /// Save token to SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Clear authentication state
  Future<void> _clearAuth() async {
    _user = null;
    _token = null;
    _apiService.setAuthToken('');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    // Schedule notification for after the current frame to avoid calling during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Upload new avatar to Supabase Storage and update user profile
  /// Accepts Uint8List (bytes from XFile.readAsBytes())
  Future<void> uploadNewAvatar(Uint8List imageBytes, String fileName) async {
    if (_user == null) throw Exception('No user logged in');

    try {
      // Extract file extension from fileName
      final fileExtension = fileName.split('.').last.toLowerCase();
      final filePath = '${_user!.id}/avatar.$fileExtension';

      // Upload to Supabase Storage as binary data
      await _supabaseClient.storage.from('avatars').uploadBinary(
            filePath,
            imageBytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
              contentType: 'image/*',
            ),
          );

      // Get public URL with cache-buster
      final publicUrl =
          _supabaseClient.storage.from('avatars').getPublicUrl(filePath);
      final urlWithCacheBuster =
          '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';

      // Update database via Hono API
      final newUrl = await _apiService.updateUserAvatar(urlWithCacheBuster);

      // Update local state
      _user!.avatarUrl = newUrl;
      notifyListeners();
    } catch (e) {
      debugPrint('Avatar upload error: $e');
      rethrow;
    }
  }
}
