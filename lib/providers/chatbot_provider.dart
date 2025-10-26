import 'package:flutter/material.dart';
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
class ChatBotNotifier extends ChangeNotifier {
  GenerativeModel? _model;
  ChatSession? _chatSession;
  ChatBotState _state = ChatBotState();

  ChatBotState get state => _state;

  ChatBotNotifier() {
    _initializeGemini();
  }

  void _initializeGemini() {
    try {
      // Your Gemini API key
      const apiKey = 'AIzaSyDh5mnGVs0DIqWsTu_ICK_7PrUuEFk_a2I';
      
      if (apiKey.isEmpty || apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
        _state = _state.copyWith(
          error: 'Please configure your Gemini API key in lib/providers/chatbot_provider.dart',
        );
        notifyListeners();
        return;
      }

      _model = GenerativeModel(
        model: 'gemini-pro',  // Base stable model
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
      _state = _state.copyWith(
        error: 'Failed to initialize Gemini AI: ${e.toString()}',
      );
      notifyListeners();
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

    _state = _state.copyWith(
      messages: [welcomeMessage],
    );
    notifyListeners();
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

    _state = _state.copyWith(
      messages: [..._state.messages, userMsg],
      isLoading: true,
      error: null,
    );
    notifyListeners();

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

      _state = _state.copyWith(
        messages: [..._state.messages, botMessage],
        isLoading: false,
      );
      notifyListeners();
    } catch (e) {
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Sorry, I encountered an error: ${e.toString()}\n\nPlease try again.',
        isUser: false,
        timestamp: DateTime.now(),
      );

      _state = _state.copyWith(
        messages: [..._state.messages, errorMessage],
        isLoading: false,
        error: e.toString(),
      );
      notifyListeners();
    }
  }

  void clearChat() {
    _state = ChatBotState();
    notifyListeners();
    _initializeGemini();
  }

  void clearError() {
    _state = _state.copyWith(error: null);
    notifyListeners();
  }
}