import 'user_model.dart';

/// Chat room model representing a conversation with another user
class ChatRoom {
  const ChatRoom({
    required this.roomId,
    required this.otherParticipant,
  });

  final String roomId;
  final User otherParticipant;

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      roomId: json['room_id']?.toString() ?? '',
      otherParticipant: User.fromJson(json['other_participant'] ?? {}),
    );
  }
}

/// Message model for chat
class Message {
  const Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.createdAt,
    required this.isMine,
    this.senderName,
  });

  final String id;
  final String content;
  final String senderId;
  final DateTime createdAt;
  final bool isMine;
  final String? senderName;

  factory Message.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    final senderId = json['sender_id']?.toString() ?? '';
    final senderData = json['sender'] as Map<String, dynamic>?;

    // Parse UTC time and convert to local timezone (just like schedule.ts does)
    final utcTime = DateTime.tryParse(json['created_at']?.toString() ?? '');
    final localTime = utcTime?.toLocal() ?? DateTime.now();

    return Message(
      id: json['id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      senderId: senderId,
      createdAt: localTime,
      isMine: currentUserId != null && senderId == currentUserId,
      senderName: senderData?['full_name']?.toString(),
    );
  }
}
