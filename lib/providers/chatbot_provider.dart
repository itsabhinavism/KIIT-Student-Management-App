import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/chat_message.dart';

// State class to manage chat data
class ChatBotState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  ChatBotState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatBotState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatBotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// ChatBot Provider
class ChatBotNotifier extends StateNotifier<ChatBotState> {
  GenerativeModel? _model;
  ChatSession? _chatSession;

  ChatBotNotifier() : super(ChatBotState()) {
    _initializeGemini();
  }

  void _initializeGemini() {
    try {
      // Your Gemini API key
      const apiKey = 'AIzaSyDh5mnGVs0DIqWsTu_ICK_7PrUuEFk_a2I';
      
      if (apiKey.isEmpty || apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
        state = state.copyWith(
          error: 'Please configure your Gemini API key in lib/providers/chatbot_provider.dart',
        );
        return;
      }

      _model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',  // Use latest stable version
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 1024,
        ),
        safetySettings: [
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
        ],
      );

      // Initialize chat with context about KIIT
      _chatSession = _model!.startChat(history: [
        Content.text(
          'You are a helpful AI assistant for KIIT (Kalinga Institute of Industrial Technology) students. '
          'You can help with queries about academics, attendance, fees, events, timetables, and general student information. '
          'Be friendly, concise, and helpful. If you don\'t know something specific about KIIT, admit it and offer general guidance.'
        ),
        Content.model([TextPart('I understand. I\'m here to help KIIT students with their queries. How can I assist you today?')]),
      ]);

      // Add welcome message
      _addWelcomeMessage();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to initialize Gemini AI: ${e.toString()}',
      );
    }
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: 'Hello! I\'m your KIIT AI assistant. I can help you with:\n\n'
          '• Academic queries\n'
          '• Attendance information\n'
          '• Fee details\n'
          '• Event information\n'
          '• Timetable queries\n'
          '• General student support\n\n'
          'How can I help you today?',
      isUser: false,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [welcomeMessage],
    );
  }

  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    // Add user message
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: userMessage.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      error: null,
    );

    try {
      if (_chatSession == null) {
        throw Exception('Chat session not initialized. Please check your API key.');
      }

      // Send message to Gemini
      final response = await _chatSession!.sendMessage(
        Content.text(userMessage.trim()),
      );

      final botMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response.text ?? 'Sorry, I couldn\'t generate a response.',
        isUser: false,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, botMessage],
        isLoading: false,
      );
    } catch (e) {
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Sorry, I encountered an error: ${e.toString()}\n\nPlease try again.',
        isUser: false,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, errorMessage],
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearChat() {
    state = ChatBotState();
    _initializeGemini();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider definition
final chatBotProvider = StateNotifierProvider<ChatBotNotifier, ChatBotState>(
  (ref) => ChatBotNotifier(),
);
