import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chat_model.dart';
import '../../services/api_service.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_drawer.dart';
import 'chat_screen.dart';
import 'start_chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late Future<List<ChatRoom>> _chatRoomsFuture;

  @override
  void initState() {
    super.initState();
    _loadChatRooms();
  }

  void _loadChatRooms() {
    final apiService = context.read<ApiService>();
    _chatRoomsFuture = apiService.getChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();
    final isStudent = authProvider.user?.role == 'student';

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: isStudent
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StartChatScreen(),
                  ),
                ).then((_) {
                  // Refresh list when returning
                  setState(() {
                    _loadChatRooms();
                  });
                });
              },
              backgroundColor: Colors.blue.shade700,
              icon: const Icon(Icons.add_comment),
              label: const Text('New Chat'),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadChatRooms();
          });
        },
        child: FutureBuilder<List<ChatRoom>>(
          future: _chatRoomsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No conversations yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isStudent
                          ? 'Tap "New Chat" to start a conversation with your teachers'
                          : 'Students will appear here when they message you',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final rooms = snapshot.data!;

            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                final participant = room.otherParticipant;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: participant.role == 'teacher'
                          ? Colors.blue.shade100
                          : Colors.green.shade100,
                      child: Icon(
                        participant.role == 'teacher'
                            ? Icons.person
                            : Icons.school,
                        color: participant.role == 'teacher'
                            ? Colors.blue.shade700
                            : Colors.green.shade700,
                      ),
                    ),
                    title: Text(
                      participant.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      participant.role == 'teacher' ? 'Teacher' : 'Student',
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade400,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            roomId: room.roomId,
                            roomName: participant.fullName,
                          ),
                        ),
                      ).then((_) {
                        // Refresh list when returning from chat
                        setState(() {
                          _loadChatRooms();
                        });
                      });
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
