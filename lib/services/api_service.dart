import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/user_model.dart';
import '../models/section_model.dart';
import '../models/enrollment_model.dart';
import '../models/schedule_model.dart' hide Section;
import '../models/fee_model.dart';
import '../models/attendance_model.dart';
import '../models/chat_model.dart';
import '../models/course_model.dart';

/// ApiService: The "Brain" - Handles all HTTP communication with Hono.js backend
/// This is a plain Dart class (not a ChangeNotifier)
class ApiService {
  final String _baseUrl = AppConfig.apiBaseUrl;
  String? _token;

  /// Set authentication token for API requests
  void setAuthToken(String token) {
    _token = token;
  }

  /// Get headers with auth token
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  /// Helper method to handle HTTP responses
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      final error = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      throw Exception(error['message'] ??
          'Request failed with status ${response.statusCode}');
    }
  }

  // ============= USER ENDPOINTS =============

  /// GET /users/me - Get current user profile
  Future<User> getMyProfile() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/me'),
      headers: _headers,
    );
    final data = _handleResponse(response);
    return User.fromJson(data);
  }

  // ============= ENROLLMENT ENDPOINTS =============

  /// GET /enrollments/my - Get user's enrollments
  Future<List<Enrollment>> getMyEnrollments() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/sections/my'),
      headers: _headers,
    );
    final data = _handleResponse(response) as List;
    return data.map((json) => Enrollment.fromJson(json)).toList();
  }

  Future<List<Course>> getMyCourses() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/sections/my-courses'),
      headers: _headers,
    );
    final data = _handleResponse(response) as List;
    return data.map((json) => Course.fromJson(json)).toList();
  }

  /// GET /sections - Get available sections for enrollment
  Future<List<Section>> getAvailableSections() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/sections'),
      headers: _headers,
    );
    final data = _handleResponse(response) as List;
    return data.map((json) => Section.fromJson(json)).toList();
  }

  /// POST /sections/:sectionId/enroll - Enroll in a section
  Future<void> enrollInSection(String sectionId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/sections/$sectionId/enroll'),
      headers: _headers,
    );
    _handleResponse(response);
  }

  // ============= SCHEDULE ENDPOINTS =============

  /// GET /schedule/today - Get today's schedule
  Future<List<ScheduleItem>> getTodaySchedule() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/schedule/today'),
      headers: _headers,
    );
    final data = _handleResponse(response) as List;
    return data.map((json) => ScheduleItem.fromJson(json)).toList();
  }

  // ============= FEE ENDPOINTS =============

  /// GET /fees/summary - Get fee summary
  Future<FeeSummary> getFeeSummary() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/fees/summary'),
      headers: _headers,
    );
    final data = _handleResponse(response);
    return FeeSummary.fromJson(data);
  }

  /// GET /fees - Get all fees
  Future<List<Fee>> getFees() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/fees'),
      headers: _headers,
    );
    final data = _handleResponse(response) as List;
    return data.map((json) => Fee.fromJson(json)).toList();
  }

  // ============= ATTENDANCE ENDPOINTS =============

  /// GET /attendance/summary - Get attendance summary
  Future<List<AttendanceSummary>> getAttendanceSummary() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/attendance/summary'),
      headers: _headers,
    );
    final data = _handleResponse(response) as List;
    return data.map((json) => AttendanceSummary.fromJson(json)).toList();
  }

  /// POST /attendance/session - Create attendance session (Teacher only)
  Future<String> createAttendanceSession({
    required String courseId,
    required String sectionId,
    required double latitude,
    required double longitude,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/attendance/session'),
      headers: _headers,
      body: jsonEncode({
        'course_id': courseId,
        'section_id': sectionId,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );
    final data = _handleResponse(response);
    return data['token'] ?? data['session_token'] ?? '';
  }

  /// POST /attendance/scan - Scan attendance QR code (Student only)
  /// Returns a success message when attendance is marked successfully
  /// Throws an exception if validation fails (token expired, too far, already marked, etc.)
  Future<Map<String, dynamic>> scanAttendance({
    required String token,
    required double latitude,
    required double longitude,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/attendance/scan'),
      headers: _headers,
      body: jsonEncode({
        'token': token,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );
    final data = _handleResponse(response);
    return {
      'success': data['success'] ?? true,
      'message': data['message'] ?? 'Attendance recorded successfully',
    };
  }

  // ============= CHAT ENDPOINTS =============

  /// GET /chat/contacts - Get available teachers to chat with (Student only)
  Future<List<User>> getChatContacts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/chat/contacts'),
      headers: _headers,
    );
    final data = _handleResponse(response) as List;
    return data.map((json) => User.fromJson(json)).toList();
  }

  /// GET /chat/rooms - Get chat rooms
  Future<List<ChatRoom>> getChatRooms() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/chat/rooms'),
      headers: _headers,
    );
    final data = _handleResponse(response) as List;
    return data.map((json) => ChatRoom.fromJson(json)).toList();
  }

  /// POST /chat/initiate - Initiate new chat
  Future<String> initiateChat(String recipientId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/chat/initiate'),
      headers: _headers,
      body: jsonEncode({'recipient_id': recipientId}),
    );
    final data = _handleResponse(response);
    return data['room_id'] ?? data['roomId'] ?? '';
  }

  /// GET /chat/rooms/:roomId/messages - Get messages for a chat room
  Future<List<Message>> getMessages(String roomId,
      {String? currentUserId}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/chat/rooms/$roomId/messages'),
      headers: _headers,
    );
    final data = _handleResponse(response) as List;
    return data
        .map((json) => Message.fromJson(json, currentUserId: currentUserId))
        .toList();
  }

  /// POST /chat/rooms/:roomId/messages - Send message
  Future<void> sendMessage(String roomId, String content) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/chat/rooms/$roomId/messages'),
      headers: _headers,
      body: jsonEncode({'content': content}),
    );
    _handleResponse(response);
  }
}
