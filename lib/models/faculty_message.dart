class FacultyMessage {
  final String id;
  final String content;
  final String senderId;
  final String senderName;
  final String senderRole; // 'student' or 'faculty'
  final DateTime timestamp;
  final bool isRead;
  final String? attachment;

  FacultyMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.timestamp,
    this.isRead = false,
    this.attachment,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'senderName': senderName,
      'senderRole': senderRole,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'attachment': attachment,
    };
  }

  factory FacultyMessage.fromJson(Map<String, dynamic> json) {
    return FacultyMessage(
      id: json['id'],
      content: json['content'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      senderRole: json['senderRole'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      attachment: json['attachment'],
    );
  }
}

class ChatRoom {
  final String id;
  final String studentId;
  final String studentName;
  final String facultyId;
  final String facultyName;
  final String subject;
  final DateTime lastMessageTime;
  final String lastMessage;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.facultyId,
    required this.facultyName,
    required this.subject,
    required this.lastMessageTime,
    required this.lastMessage,
    this.unreadCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'facultyId': facultyId,
      'facultyName': facultyName,
      'subject': subject,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'lastMessage': lastMessage,
      'unreadCount': unreadCount,
    };
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      studentId: json['studentId'],
      studentName: json['studentName'],
      facultyId: json['facultyId'],
      facultyName: json['facultyName'],
      subject: json['subject'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      lastMessage: json['lastMessage'],
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}
