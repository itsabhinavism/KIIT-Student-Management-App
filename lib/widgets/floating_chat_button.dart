import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../screens/chatbot_screen.dart';
import '../main.dart';

// Provider to manage the floating button position
final floatingButtonPositionProvider = StateProvider<Offset>((ref) {
  return const Offset(20, 100); // Default position
});

class FloatingChatButton extends ConsumerStatefulWidget {
  const FloatingChatButton({super.key});

  @override
  ConsumerState<FloatingChatButton> createState() => _FloatingChatButtonState();
}

class _FloatingChatButtonState extends ConsumerState<FloatingChatButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _isDragging = false;
  Offset? _dragStartPosition;

  void _openChatBot() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Use the global navigator key to push the route
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const ChatBotScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(floatingButtonPositionProvider);
    final isDarkMode = ref.watch(themeProvider) == AppTheme.dark;
    final screenSize = MediaQuery.of(context).size;

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanStart: (details) {
          _isDragging = false;
          _dragStartPosition = details.globalPosition;
        },
        onPanUpdate: (details) {
          // Mark as dragging if moved more than 5 pixels
          if (!_isDragging && _dragStartPosition != null) {
            final distance = (details.globalPosition - _dragStartPosition!).distance;
            if (distance > 5) {
              _isDragging = true;
            }
          }
          
          if (_isDragging) {
            final newPosition = Offset(
              (position.dx + details.delta.dx).clamp(
                0.0,
                screenSize.width - 60,
              ),
              (position.dy + details.delta.dy).clamp(
                0.0,
                screenSize.height - 60,
              ),
            );
            ref.read(floatingButtonPositionProvider.notifier).state = newPosition;
          }
        },
        onPanEnd: (details) {
          // If not dragging (just a tap), open the chatbot
          if (!_isDragging) {
            _openChatBot();
          }
          _isDragging = false;
          _dragStartPosition = null;
        },
        onTap: _openChatBot,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.blue[700]!, Colors.blue[900]!]
                    : [Colors.blue[400]!, Colors.blue[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.smart_toy,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                // Notification badge (optional - can show unread count)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
