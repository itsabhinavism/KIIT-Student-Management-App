import 'package:flutter/material.dart';
import '../models/faculty_message.dart';

class FacultyChatNotifier extends ChangeNotifier {
  List<ChatRoom> _chatRooms = [];
  List<FacultyMessage> _currentMessages = [];
  bool _isLoading = false;
  String? _error;

  List<ChatRoom> get chatRooms => _chatRooms;
  List<FacultyMessage> get currentMessages => _currentMessages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  FacultyChatNotifier() {
    _loadMockData();
  }

  // Mock data - Replace with actual Firebase/Supabase implementation later
  void _loadMockData() {
    _chatRooms = [
      ChatRoom(
        id: '1',
        studentId: '22052611',
        studentName: 'Abhinav Anand',
        facultyId: 'F001',
        facultyName: 'Dr. Rajesh Kumar',
        subject: 'Data Structures',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
        lastMessage: 'Thank you for the clarification!',
        unreadCount: 0,
      ),
      ChatRoom(
        id: '2',
        studentId: '22052611',
        studentName: 'Abhinav Anand',
        facultyId: 'F002',
        facultyName: 'Prof. Priya Singh',
        subject: 'Algorithms',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        lastMessage: 'I have a doubt regarding the assignment...',
        unreadCount: 2,
      ),
      ChatRoom(
        id: '3',
        studentId: '22052611',
        studentName: 'Abhinav Anand',
        facultyId: 'F003',
        facultyName: 'Dr. Anil Sharma',
        subject: 'Database Systems',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        lastMessage: 'When is the next lab session?',
        unreadCount: 0,
      ),
    ];
    notifyListeners();
  }

  void loadChatRoom(String chatRoomId) {
    _isLoading = true;
    notifyListeners();

    // Mock messages - Replace with actual data fetching
    _currentMessages = [
      FacultyMessage(
        id: 'm1',
        content: 'Hello Professor, I have a doubt about linked lists.',
        senderId: '22052611',
        senderName: 'Abhinav Anand',
        senderRole: 'student',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      FacultyMessage(
        id: 'm2',
        content: 'Hello Abhinav! Sure, what would you like to know?',
        senderId: 'F001',
        senderName: 'Dr. Rajesh Kumar',
        senderRole: 'faculty',
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
        isRead: true,
      ),
      FacultyMessage(
        id: 'm3',
        content: 'Can you explain the difference between singly and doubly linked lists?',
        senderId: '22052611',
        senderName: 'Abhinav Anand',
        senderRole: 'student',
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
        isRead: true,
      ),
      FacultyMessage(
        id: 'm4',
        content: 'Certainly! In a singly linked list, each node points only to the next node. In a doubly linked list, each node has pointers to both the next and previous nodes, allowing bidirectional traversal.',
        senderId: 'F001',
        senderName: 'Dr. Rajesh Kumar',
        senderRole: 'faculty',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      FacultyMessage(
        id: 'm5',
        content: 'Thank you for the clarification!',
        senderId: '22052611',
        senderName: 'Abhinav Anand',
        senderRole: 'student',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: true,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(String chatRoomId, String content, String studentId, String studentName) async {
    final newMessage = FacultyMessage(
      id: 'm${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      senderId: studentId,
      senderName: studentName,
      senderRole: 'student',
      timestamp: DateTime.now(),
      isRead: false,
    );

    _currentMessages.add(newMessage);
    
    // Update chat room's last message
    final roomIndex = _chatRooms.indexWhere((room) => room.id == chatRoomId);
    if (roomIndex != -1) {
      _chatRooms[roomIndex] = ChatRoom(
        id: _chatRooms[roomIndex].id,
        studentId: _chatRooms[roomIndex].studentId,
        studentName: _chatRooms[roomIndex].studentName,
        facultyId: _chatRooms[roomIndex].facultyId,
        facultyName: _chatRooms[roomIndex].facultyName,
        subject: _chatRooms[roomIndex].subject,
        lastMessageTime: DateTime.now(),
        lastMessage: content,
        unreadCount: _chatRooms[roomIndex].unreadCount,
      );
    }

    notifyListeners();

    // TODO: Add Firebase/Supabase API call here
    // await _apiService.sendMessage(chatRoomId, newMessage);
  }

  void createNewChat(String facultyId, String facultyName, String subject, String studentId, String studentName) {
    final newRoom = ChatRoom(
      id: 'room_${DateTime.now().millisecondsSinceEpoch}',
      studentId: studentId,
      studentName: studentName,
      facultyId: facultyId,
      facultyName: facultyName,
      subject: subject,
      lastMessageTime: DateTime.now(),
      lastMessage: 'Chat started',
      unreadCount: 0,
    );

    _chatRooms.insert(0, newRoom);
    notifyListeners();

    // TODO: Add Firebase/Supabase API call here
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
