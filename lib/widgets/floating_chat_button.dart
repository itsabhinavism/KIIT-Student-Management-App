import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../screens/chatbot/ai_chat_screen.dart';

// Notifier to manage the floating button position and visibility
class FloatingButtonPositionNotifier extends ChangeNotifier {
  Offset _position = const Offset(20, 20); // Bottom-left position
  bool _isVisible = true;

  Offset get position => _position;
  bool get isVisible => _isVisible;

  void updatePosition(Offset newPosition) {
    _position = newPosition;
    notifyListeners();
  }

  void setVisibility(bool visible) {
    _isVisible = visible;
    notifyListeners();
  }
}

class FloatingChatButton extends StatefulWidget {
  const FloatingChatButton({super.key});

  @override
  State<FloatingChatButton> createState() => _FloatingChatButtonState();
}

class _FloatingChatButtonState extends State<FloatingChatButton>
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

    // Navigate to AI chat screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AiChatScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final positionNotifier = context.watch<FloatingButtonPositionNotifier>();
    final position = positionNotifier.position;
    final isVisible = positionNotifier.isVisible;
    final themeNotifier = context.watch<ThemeNotifier>();
    final isDarkMode = themeNotifier.theme == AppTheme.dark;
    final screenSize = MediaQuery.of(context).size;

    // Return empty widget if not visible
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return Positioned(
      right: position.dx, // Changed from left to right
      bottom: position.dy,
      child: GestureDetector(
        onPanStart: (details) {
          _isDragging = false;
          _dragStartPosition = details.globalPosition;
        },
        onPanUpdate: (details) {
          // Mark as dragging if moved more than 5 pixels
          if (!_isDragging && _dragStartPosition != null) {
            final distance =
                (details.globalPosition - _dragStartPosition!).distance;
            if (distance > 5) {
              _isDragging = true;
            }
          }

          if (_isDragging) {
            // Calculate new position from bottom
            final currentBottom = screenSize.height - position.dy - 60;
            final newBottom = currentBottom - details.delta.dy;

            final newPosition = Offset(
              (position.dx + details.delta.dx).clamp(
                0.0,
                screenSize.width - 60,
              ),
              (screenSize.height - newBottom - 60).clamp(
                0.0,
                screenSize.height - 60,
              ),
            );
            context
                .read<FloatingButtonPositionNotifier>()
                .updatePosition(newPosition);
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
                const Center(
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
