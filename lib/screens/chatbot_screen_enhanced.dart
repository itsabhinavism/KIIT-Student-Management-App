import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/chat_message.dart';
import '../providers/chatbot_provider.dart';
import '../providers/theme_provider.dart';

class ChatBotScreenEnhanced extends StatefulWidget {
  const ChatBotScreenEnhanced({super.key});

  @override
  State<ChatBotScreenEnhanced> createState() => _ChatBotScreenEnhancedState();
}

class _ChatBotScreenEnhancedState extends State<ChatBotScreenEnhanced> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  List<PlatformFile> _selectedMedia = [];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _sendMessage([String? customMessage]) {
    final message = customMessage ?? _messageController.text.trim();
    if (message.isEmpty && _selectedMedia.isEmpty) return;

    // Create copies of PlatformFile objects to ensure bytes are retained
    List<PlatformFile>? filesToSend;
    if (_selectedMedia.isNotEmpty) {
      filesToSend = _selectedMedia.map((file) {
        return PlatformFile(
          name: file.name,
          size: file.size,
          bytes: file.bytes, // Explicitly preserve bytes for web
          path: kIsWeb ? null : file.path, // Only access path on non-web platforms
        );
      }).toList();
    }

    // Send message with attached files to the chatbot
    context.read<ChatBotNotifier>().sendMessage(
      message,
      attachedFiles: filesToSend,
    );
    
    _messageController.clear();
    setState(() {
      _selectedMedia.clear();
    });
    _scrollToBottom();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // On web, camera source is not supported
      if (kIsWeb && source == ImageSource.camera) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera not available on web. Please use file picker.'),
          ),
        );
        return;
      }
      
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        // Convert XFile to PlatformFile
        final bytes = await image.readAsBytes();
        final platformFile = PlatformFile(
          name: image.name,
          size: bytes.length,
          bytes: bytes,
          path: kIsWeb ? null : image.path,
        );
        setState(() {
          _selectedMedia.add(platformFile);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png'],
        withData: kIsWeb, // Load file bytes for web
      );

      if (result != null) {
        setState(() {
          _selectedMedia.addAll(result.files);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  void _removeMedia(int index) {
    setState(() {
      _selectedMedia.removeAt(index);
    });
  }

  Widget _buildImagePreview(PlatformFile file) {
    if (kIsWeb) {
      // For web, use bytes
      if (file.bytes != null) {
        return Image.memory(
          file.bytes!,
          fit: BoxFit.cover,
          width: 80,
          height: 100,
        );
      }
    } else {
      // For mobile, use path
      if (file.path != null) {
        return Image.file(
          File(file.path!),
          fit: BoxFit.cover,
          width: 80,
          height: 100,
        );
      }
    }
    // Fallback icon
    return const Center(
      child: Icon(Icons.image, size: 40, color: Colors.grey),
    );
  }

  void _showMediaOptions(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            if (!kIsWeb) // Hide camera option on web
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: Text(kIsWeb ? 'Choose Images' : 'Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file, color: Colors.orange),
              title: const Text('Attach File'),
              onTap: () {
                Navigator.pop(context);
                _pickFile();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatNotifier = context.watch<ChatBotNotifier>();
    final chatState = chatNotifier.state;
    final themeNotifier = context.watch<ThemeNotifier>();
    final isDarkMode = themeNotifier.theme == AppTheme.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Colors.grey[850]!, Colors.grey[900]!]
                  : [Colors.blue[700]!, Colors.blue[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.blue[900]
                    : Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.smart_toy,
                color: isDarkMode ? Colors.blue[200] : Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KIIT Assistant',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Always here to help',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (chatState.messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: () => _showClearDialog(context),
              tooltip: 'Clear Chat',
            ),
        ],
      ),
      body: Column(
        children: [
          // Error Banner
          if (chatState.error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.red[100],
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[900]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      chatState.error!,
                      style: TextStyle(color: Colors.red[900], fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red[900]),
                    onPressed: () {
                      context.read<ChatBotNotifier>().clearError();
                    },
                  ),
                ],
              ),
            ),

          // Messages List
          Expanded(
            child: chatState.messages.isEmpty
                ? _buildEmptyState(isDarkMode)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chatState.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatState.messages[index];
                      return _EnhancedMessageBubble(
                        message: message,
                        isDarkMode: isDarkMode,
                      );
                    },
                  ),
          ),

          // Loading Indicator
          if (chatState.isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBouncingDots(isDarkMode),
                  const SizedBox(width: 12),
                  Text(
                    'Thinking...',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          // Quick Suggestions
          _buildQuickSuggestions(context, chatState, isDarkMode),

          // Input Area
          _buildInputArea(context, chatState, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [Colors.blue[900]!, Colors.blue[700]!]
                      : [Colors.blue[400]!, Colors.blue[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to KIIT Assistant!',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'I have complete access to your student data',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              'Quick Start Ideas:',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildStartIdea(
              isDarkMode,
              Icons.bar_chart,
              'View Attendance',
              'Check your overall and subject-wise attendance',
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildStartIdea(
              isDarkMode,
              Icons.account_balance_wallet,
              'Fee Status',
              'See your payment status and pending fees',
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildStartIdea(
              isDarkMode,
              Icons.school,
              'Academic Performance',
              'Review your CGPA, grades, and credits',
              Colors.purple,
            ),
            const SizedBox(height: 12),
            _buildStartIdea(
              isDarkMode,
              Icons.event,
              'Upcoming Events',
              'Check what events are coming up',
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartIdea(
    bool isDarkMode,
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBouncingDots(bool isDarkMode) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return TweenAnimationBuilder<double>(
          key: ValueKey(index),
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            final animationValue = (value + index * 0.3) % 1.0;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.translate(
                offset: Offset(
                  0,
                  -10 * (0.5 - (animationValue - 0.5).abs()) * 2,
                ),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.blue[300] : Colors.blue[600],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildQuickSuggestions(
    BuildContext context,
    ChatBotState chatState,
    bool isDarkMode,
  ) {
    if (chatState.messages.isNotEmpty || chatState.isLoading) {
      return const SizedBox.shrink();
    }

    final suggestions = [
      {
        'icon': Icons.bar_chart,
        'text': 'My Attendance',
        'query': 'Show my complete attendance breakdown'
      },
      {
        'icon': Icons.attach_money,
        'text': 'Fee Status',
        'query': 'What is my fee payment status?'
      },
      {
        'icon': Icons.school,
        'text': 'My Grades',
        'query': 'Summarize my academic performance'
      },
      {
        'icon': Icons.calendar_today,
        'text': 'Today\'s Classes',
        'query': 'What classes do I have today?'
      },
      {
        'icon': Icons.event,
        'text': 'Events',
        'query': 'What events are coming up?'
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: suggestions.map((suggestion) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => _sendMessage(suggestion['query'] as String),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [Colors.blue[900]!, Colors.blue[800]!]
                          : [Colors.blue[500]!, Colors.blue[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        suggestion['icon'] as IconData,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        suggestion['text'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInputArea(
    BuildContext context,
    ChatBotState chatState,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Media preview section
            if (_selectedMedia.isNotEmpty)
              Container(
                padding: const EdgeInsets.only(bottom: 12),
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedMedia.length,
                  itemBuilder: (context, index) {
                    final file = _selectedMedia[index];
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: file.name.endsWith('.pdf') ||
                                    file.name.endsWith('.doc') ||
                                    file.name.endsWith('.docx') ||
                                    file.name.endsWith('.txt')
                                ? Center(
                                    child: Icon(
                                      Icons.insert_drive_file,
                                      size: 40,
                                      color: isDarkMode
                                          ? Colors.blue[300]
                                          : Colors.blue[600],
                                    ),
                                  )
                                : _buildImagePreview(file),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeMedia(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            // Input row
            Row(
              children: [
                // Attachment button
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: isDarkMode ? Colors.blue[300] : Colors.blue[600],
                    ),
                    onPressed: () => _showMediaOptions(context, isDarkMode),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        hintStyle: TextStyle(
                          color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                        ),
                        filled: true,
                        fillColor:
                            isDarkMode ? Colors.grey[800] : Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.grey[700]!
                                : Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.blue[700]!
                                : Colors.blue[600]!,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontSize: 15,
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: !chatState.isLoading,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [Colors.blue[700]!, Colors.blue[800]!]
                          : [Colors.blue[500]!, Colors.blue[700]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      chatState.isLoading ? Icons.stop : Icons.send_rounded,
                      size: 22,
                    ),
                    color: Colors.white,
                    onPressed: chatState.isLoading ? null : () => _sendMessage(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Chat History'),
          content: const Text(
            'Are you sure you want to clear all messages? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<ChatBotNotifier>().clearChat();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Enhanced Message Bubble with animations
class _EnhancedMessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool isDarkMode;

  const _EnhancedMessageBubble({
    required this.message,
    required this.isDarkMode,
  });

  @override
  State<_EnhancedMessageBubble> createState() => _EnhancedMessageBubbleState();
}

class _EnhancedMessageBubbleState extends State<_EnhancedMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.message.isUser
          ? const Offset(0.3, 0)
          : const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: widget.message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.message.isUser) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.isDarkMode
                          ? [Colors.blue[900]!, Colors.blue[800]!]
                          : [Colors.blue[300]!, Colors.blue[500]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.smart_toy,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: widget.message.isUser
                        ? LinearGradient(
                            colors: widget.isDarkMode
                                ? [Colors.blue[700]!, Colors.blue[800]!]
                                : [Colors.blue[500]!, Colors.blue[700]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: !widget.message.isUser
                        ? (widget.isDarkMode
                            ? Colors.grey[800]
                            : Colors.grey[100])
                        : null,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft:
                          Radius.circular(widget.message.isUser ? 20 : 4),
                      bottomRight:
                          Radius.circular(widget.message.isUser ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.message.isUser
                            ? Colors.blue.withOpacity(0.3)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show image thumbnails if there are attachments
                      if (widget.message.attachments != null && 
                          widget.message.attachments!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: widget.message.attachments!
                                .where((file) {
                                  final name = file.name.toLowerCase();
                                  return name.endsWith('.jpg') ||
                                      name.endsWith('.jpeg') ||
                                      name.endsWith('.png') ||
                                      name.endsWith('.gif') ||
                                      name.endsWith('.webp');
                                })
                                .take(3) // Show max 3 thumbnails
                                .map((file) => _buildAttachmentThumbnail(file))
                                .toList(),
                          ),
                        ),
                      // Show file count if there are non-image attachments
                      if (widget.message.attachments != null && 
                          widget.message.attachments!.any((file) {
                            final name = file.name.toLowerCase();
                            return !name.endsWith('.jpg') &&
                                !name.endsWith('.jpeg') &&
                                !name.endsWith('.png') &&
                                !name.endsWith('.gif') &&
                                !name.endsWith('.webp');
                          }))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.attach_file,
                                size: 14,
                                color: widget.message.isUser
                                    ? Colors.white70
                                    : (widget.isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600]),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.message.attachments!.where((f) {
                                  final name = f.name.toLowerCase();
                                  return !name.endsWith('.jpg') &&
                                      !name.endsWith('.jpeg') &&
                                      !name.endsWith('.png') &&
                                      !name.endsWith('.gif') &&
                                      !name.endsWith('.webp');
                                }).length} file(s)',
                                style: TextStyle(
                                  color: widget.message.isUser
                                      ? Colors.white70
                                      : (widget.isDarkMode
                                          ? Colors.grey[400]
                                          : Colors.grey[600]),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Text(
                        widget.message.content,
                        style: TextStyle(
                          color: widget.message.isUser
                              ? Colors.white
                              : (widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black87),
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 10,
                            color: widget.message.isUser
                                ? Colors.white70
                                : (widget.isDarkMode
                                    ? Colors.grey[500]
                                    : Colors.grey[600]),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeFormat.format(widget.message.timestamp),
                            style: TextStyle(
                              color: widget.message.isUser
                                  ? Colors.white70
                                  : (widget.isDarkMode
                                      ? Colors.grey[500]
                                      : Colors.grey[600]),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.message.isUser) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.isDarkMode
                          ? [Colors.grey[700]!, Colors.grey[800]!]
                          : [Colors.grey[300]!, Colors.grey[400]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    size: 22,
                    color:
                        widget.isDarkMode ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentThumbnail(PlatformFile file) {
    // Debug: Check if bytes are available
    final hasBytes = file.bytes != null;
    final hasPath = !kIsWeb && file.path != null; // Only check path on non-web
    
    // Show image or placeholder
    Widget imageWidget;
    if (kIsWeb) {
      if (hasBytes) {
        imageWidget = Image.memory(
          file.bytes!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading image from bytes: $error');
            return _buildFileIcon();
          },
        );
      } else {
        print('Warning: No bytes available for file ${file.name} on web');
        imageWidget = _buildFileIcon();
      }
    } else {
      if (hasPath) {
        imageWidget = Image.file(
          File(file.path!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading image from path: $error');
            return _buildFileIcon();
          },
        );
      } else {
        print('Warning: No path available for file ${file.name} on mobile');
        imageWidget = _buildFileIcon();
      }
    }
    
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: widget.message.isUser
              ? Colors.white.withOpacity(0.3)
              : (widget.isDarkMode
                  ? Colors.grey[700]!
                  : Colors.grey[300]!),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: imageWidget,
      ),
    );
  }

  Widget _buildFileIcon() {
    return Center(
      child: Icon(
        Icons.image,
        size: 24,
        color: widget.message.isUser
            ? Colors.white.withOpacity(0.5)
            : (widget.isDarkMode
                ? Colors.grey[600]
                : Colors.grey[400]),
      ),
    );
  }
}
