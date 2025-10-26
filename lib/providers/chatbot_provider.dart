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
  Map<String, dynamic>? _appContext;

  ChatBotState get state => _state;

  ChatBotNotifier() {
    _initializeGemini();
  }

  // Method to update app context data
  void updateAppContext(Map<String, dynamic> context) {
    _appContext = context;
    notifyListeners();
  }

  String _buildContextualPrompt() {
    if (_appContext == null) return '';

    final StringBuffer contextInfo = StringBuffer('\n\n=== COMPLETE STUDENT DATA ACCESS ===\n\n');
    
    // STUDENT IDENTITY
    if (_appContext!.containsKey('rollNumber')) {
      contextInfo.write('STUDENT IDENTITY:\n');
      contextInfo.write('Roll Number: ${_appContext!['rollNumber']}\n');
      if (_appContext!.containsKey('studentName')) {
        contextInfo.write('Name: ${_appContext!['studentName']}\n');
      }
      if (_appContext!.containsKey('personalInfo')) {
        final info = _appContext!['personalInfo'];
        contextInfo.write('Email: ${info['email']}\n');
        contextInfo.write('Branch: ${info['branch']}\n');
        contextInfo.write('Section: ${info['section']}\n');
        contextInfo.write('Mentor: ${info['mentor']}\n');
        contextInfo.write('Admission Year: ${info['yearOfAdmission']}\n');
        contextInfo.write('Expected Graduation: ${info['expectedGraduation']}\n');
      }
      contextInfo.write('\n');
    }
    
    // ATTENDANCE DATA (Tab 1)
    if (_appContext!.containsKey('attendance')) {
      final attendance = _appContext!['attendance'];
      contextInfo.write('ATTENDANCE DATA (FROM ATTENDANCE TAB):\n');
      contextInfo.write('Overall Attendance: ${attendance['overall']}% (${attendance['classesAttended']}/${attendance['totalClasses']} classes attended, ${attendance['classesAbsent']} absent)\n');
      contextInfo.write('Semester: ${attendance['semester']}\n');
      contextInfo.write('Department: ${attendance['department']}\n\n');
      
      if (attendance['subjects'] != null) {
        contextInfo.write('Subject-wise Attendance Details:\n');
        final subjects = attendance['subjects'] as Map;
        subjects.forEach((subject, data) {
          if (data is Map) {
            contextInfo.write('- $subject: ${data['percentage']}% (Attended: ${data['attended']}/${data['total']}, Absent: ${data['absent']} classes)\n');
          }
        });
        contextInfo.write('\n');
      }
    }

    // FEES DATA (Tab 3)
    if (_appContext!.containsKey('fees')) {
      final fees = _appContext!['fees'];
      contextInfo.write('FEE PAYMENT STATUS (FROM FEES TAB):\n');
      contextInfo.write('Total Fees: Rs.${fees['totalFees']}\n');
      contextInfo.write('Amount Paid: Rs.${fees['paidAmount']}\n');
      contextInfo.write('Amount Pending: Rs.${fees['pendingAmount']}\n');
      contextInfo.write('Payment Status: ${fees['paymentStatus']}\n');
      contextInfo.write('Last Payment: Rs.${fees['lastPaymentAmount']} on ${fees['lastPaymentDate']}\n');
      contextInfo.write('Next Due Date: ${fees['nextDueDate']}\n\n');
      
      if (fees['breakdown'] != null) {
        contextInfo.write('Fee Breakdown:\n');
        final breakdown = fees['breakdown'] as Map;
        breakdown.forEach((category, amount) {
          contextInfo.write('- $category: Rs.$amount\n');
        });
        contextInfo.write('\n');
      }
      
      if (fees['paymentHistory'] != null) {
        contextInfo.write('Payment History:\n');
        final history = fees['paymentHistory'] as List;
        for (var payment in history) {
          contextInfo.write('- ${payment['date']}: Rs.${payment['amount']} via ${payment['mode']}\n');
        }
        contextInfo.write('\n');
      }
    }

    // ACADEMIC REPORT DATA (Tab 4)
    if (_appContext!.containsKey('academicReport')) {
      final report = _appContext!['academicReport'];
      contextInfo.write('ACADEMIC PERFORMANCE (FROM REPORT TAB):\n');
      contextInfo.write('Current Semester: ${report['currentSemester']}\n');
      contextInfo.write('Current CGPA: ${report['currentCGPA']}\n');
      contextInfo.write('Previous Semester SGPA: ${report['previousSemesterSGPA']}\n');
      contextInfo.write('Total Credits Completed: ${report['totalCreditsCompleted']}\n');
      contextInfo.write('Backlogs: ${report['backlogsCount']}\n');
      contextInfo.write('Class Rank: ${report['rank']}\n\n');
      
      if (report['semesterResults'] != null) {
        contextInfo.write('Semester-wise Results:\n');
        final results = report['semesterResults'] as List;
        for (var sem in results) {
          contextInfo.write('- Semester ${sem['semester']}: SGPA ${sem['sgpa']} (${sem['status']})\n');
        }
        contextInfo.write('\n');
      }
      
      if (report['currentSubjects'] != null) {
        contextInfo.write('Current Semester Subject Performance:\n');
        final subjects = report['currentSubjects'] as Map;
        subjects.forEach((subject, data) {
          contextInfo.write('- $subject: Grade ${data['grade']}, Marks ${data['marks']}, Credits ${data['credits']}\n');
        });
        contextInfo.write('\n');
      }
    }

    // EVENTS DATA (Tab 5)
    if (_appContext!.containsKey('events')) {
      final events = _appContext!['events'] as List;
      if (events.isNotEmpty) {
        contextInfo.write('UPCOMING EVENTS (FROM EVENTS TAB - Total: ${events.length}):\n');
        for (var event in events) {
          contextInfo.write('- ${event['name']} on ${event['date']} at ${event['location']}\n');
          contextInfo.write('  Category: ${event['category']}, Description: ${event['description']}\n');
        }
        contextInfo.write('\n');
      }
    }

    // TIMETABLE DATA (Tab 6)
    if (_appContext!.containsKey('timetable')) {
      final timetable = _appContext!['timetable'];
      contextInfo.write('CLASS SCHEDULE (FROM TIMETABLE TAB):\n');
      contextInfo.write('Today\'s Classes: ${timetable['todayClasses']}\n');
      contextInfo.write('Next Class: ${timetable['nextClass']}\n');
      if (timetable['todaySubjects'] != null) {
        contextInfo.write('Today\'s Subjects: ${(timetable['todaySubjects'] as List).join(', ')}\n');
      }
      contextInfo.write('\n');
      
      if (timetable['weeklySchedule'] != null) {
        contextInfo.write('Weekly Schedule:\n');
        final schedule = timetable['weeklySchedule'] as Map;
        schedule.forEach((day, classes) {
          contextInfo.write('$day: ${(classes as List).join(', ')}\n');
        });
        contextInfo.write('\n');
      }
    }

    contextInfo.write('=== END OF DATA ===\n');
    return contextInfo.toString();
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
        model: 'gemini-2.5-pro',  // Using Gemini 2.5 Pro model
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

      // Initialize chat with context about KIIT and student data
      final systemPrompt = 'You are a helpful AI assistant for KIIT (Kalinga Institute of Industrial Technology) students. '
          'You have access to the student\'s current app data including attendance, fees, events, and timetable. '
          'When asked about their data, provide specific information from the context provided. '
          'You can summarize their attendance, fee status, upcoming events, and class schedules. '
          'Be friendly, concise, and helpful. Always use the provided context data when answering questions about the student\'s information. '
          'IMPORTANT: Do NOT use asterisks or any markdown formatting like bold or italics in your responses. '
          'Write responses in plain text only. Do not use symbols like *, **, _, __, or any other formatting markers. '
          'When listing items, use simple dashes or numbers. When emphasizing words, use capital letters or quotes instead of asterisks.'
          '${_buildContextualPrompt()}';

      _chatSession = _model!.startChat(history: [
        Content.text(systemPrompt),
        Content.model([TextPart('I understand. I am your KIIT AI assistant with access to your student data. I can help you with queries about your attendance, fees, events, timetables, and more. I will provide responses in plain text without using asterisks or formatting markers. How can I assist you today?')]),
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
    String contextSummary = '';
    if (_appContext != null) {
      contextSummary += '\n\n📊 Quick Overview:';
      if (_appContext!.containsKey('attendance')) {
        final attendance = _appContext!['attendance'];
        contextSummary += '\n• Attendance: ${attendance['overall']}% (${attendance['classesAttended']}/${attendance['totalClasses']} classes)';
      }
      if (_appContext!.containsKey('academicReport')) {
        final report = _appContext!['academicReport'];
        contextSummary += '\n• CGPA: ${report['currentCGPA']} | Rank: ${report['rank']}';
      }
      if (_appContext!.containsKey('fees') && _appContext!['fees']['pendingAmount'] > 0) {
        contextSummary += '\n• Pending Fees: Rs.${_appContext!['fees']['pendingAmount']}';
      }
      if (_appContext!.containsKey('events')) {
        final events = _appContext!['events'] as List;
        contextSummary += '\n• Upcoming Events: ${events.length}';
      }
      if (_appContext!.containsKey('timetable')) {
        final timetable = _appContext!['timetable'];
        contextSummary += '\n• Today\'s Classes: ${timetable['todayClasses']}';
      }
    }

    final welcomeMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: 'Hello! I am your KIIT AI Assistant with complete access to your student data across ALL tabs.\n'
          '$contextSummary\n\n'
          '💡 What I can help you with:\n'
          '• Attendance summary and subject-wise breakdown\n'
          '• Fee payment status and payment history\n'
          '• Academic performance, CGPA, and grades\n'
          '• Upcoming events and deadlines\n'
          '• Weekly timetable and class schedules\n'
          '• Personal information and mentor details\n\n'
          '🎯 Try asking:\n'
          '"Show my complete attendance breakdown"\n'
          '"What is my fee status?"\n'
          '"Summarize my academic performance"\n'
          '"What events are coming up?"\n'
          '"Show my weekly timetable"\n'
          '"Give me a full overview of everything"',
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

      // Build enhanced prompt with current context
      String enhancedMessage = userMessage.trim();
      if (_appContext != null && _appContext!.isNotEmpty) {
        enhancedMessage += '\n\n[Current Student Data: ${_buildContextualPrompt()}]';
      }

      // Send message to Gemini
      final response = await _chatSession!.sendMessage(
        Content.text(enhancedMessage),
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