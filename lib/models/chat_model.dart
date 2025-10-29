/// Chat room model
class ChatRoom {
  const ChatRoom({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  final String id;
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      lastMessage: json['last_message']?.toString() ??
          json['lastMessage']?.toString() ??
          '',
      lastMessageTime: DateTime.tryParse(
              json['last_message_time']?.toString() ??
                  json['lastMessageTime']?.toString() ??
                  '') ??
          DateTime.now(),
      unreadCount: _parseInt(json['unread_count'] ?? json['unreadCount']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}

/// Message model for chat
class Message {
  const Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.isOwnMessage,
  });

  final String id;
  final String roomId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final bool isOwnMessage;

  factory Message.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    return Message(
      id: json['id']?.toString() ?? '',
      roomId: json['room_id']?.toString() ?? json['roomId']?.toString() ?? '',
      senderId:
          json['sender_id']?.toString() ?? json['senderId']?.toString() ?? '',
      senderName: json['sender_name']?.toString() ??
          json['senderName']?.toString() ??
          '',
      content: json['content']?.toString() ?? '',
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ??
              json['created_at']?.toString() ??
              '') ??
          DateTime.now(),
      isOwnMessage: currentUserId != null &&
          json['sender_id']?.toString() == currentUserId,
    );
  }
}
