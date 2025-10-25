# AI Chatbot Setup Guide for KIIT Student Management App

## Overview
This guide will walk you through setting up the AI-powered chatbot feature using Google's Gemini API.

## Features Implemented

✅ **Floating Chat Button**
- Draggable circular button that appears on all screens
- Smooth animations and theme-aware design
- Green indicator showing the bot is active

✅ **Full-Featured Chat Interface**
- Message bubbles with timestamps
- Loading indicators while AI thinks
- Error handling and retry capability
- Theme support (dark/light mode)
- Chat history within session
- Clear chat functionality

✅ **Gemini AI Integration**
- Context-aware responses about KIIT
- Natural conversation flow
- Safety settings configured
- Optimized for student queries

---

## Step-by-Step Setup Instructions

### Step 1: Get Your Gemini API Key

1. **Visit Google AI Studio**
   - Go to: https://makersuite.google.com/app/apikey
   - Or: https://aistudio.google.com/app/apikey

2. **Sign in with your Google Account**
   - Use any Google account (personal or institutional)

3. **Create an API Key**
   - Click on "Create API Key" button
   - Select "Create API key in new project" or choose existing project
   - Copy the generated API key (it will look like: `AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`)
   
   ⚠️ **Important**: Keep this API key secure and never commit it to public repositories!

### Step 2: Configure the API Key in Your App

1. **Open the chatbot provider file**
   ```
   lib/providers/chatbot_provider.dart
   ```

2. **Find line 42** which looks like:
   ```dart
   const apiKey = 'YOUR_GEMINI_API_KEY_HERE';
   ```

3. **Replace** `YOUR_GEMINI_API_KEY_HERE` with your actual API key:
   ```dart
   const apiKey = 'AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
   ```

### Step 3: Run the App

1. **Make sure dependencies are installed**
   ```bash
   flutter pub get
   ```

2. **Run the app**
   ```bash
   flutter run
   ```

3. **Test the chatbot**
   - You should see a blue floating button with a robot icon
   - Tap it to open the chat interface
   - Try asking questions like:
     - "What is KIIT?"
     - "How can I check my attendance?"
     - "Tell me about upcoming events"
     - "What are the fee payment options?"

---

## File Structure Created

```
lib/
├── models/
│   └── chat_message.dart          # Chat message data model
├── providers/
│   └── chatbot_provider.dart      # Gemini AI integration & state management
├── screens/
│   └── chatbot_screen.dart        # Full chat UI with message bubbles
├── widgets/
│   └── floating_chat_button.dart  # Draggable floating button overlay
└── main.dart                      # Updated with chat button overlay
```

---

## How It Works

### Architecture

1. **State Management**: Uses Riverpod for reactive state management
2. **API Integration**: Direct integration with Gemini Pro model
3. **Overlay System**: Stack-based overlay in MaterialApp builder
4. **Position Persistence**: Floating button position saved in provider

### Chat Flow

1. User taps floating button → Opens `ChatBotScreen`
2. User types message → Sent to `ChatBotProvider`
3. Provider sends to Gemini API → Receives response
4. Response displayed as bot message bubble
5. Chat history maintained in session

### Theme Integration

The chatbot automatically adapts to your app's theme:
- **Light Mode**: Blue gradients, light backgrounds
- **Dark Mode**: Dark gradients, darker backgrounds
- Follows the existing `themeProvider` state

---

## Customization Options

### 1. Change Floating Button Position
Edit `lib/widgets/floating_chat_button.dart` line 12:
```dart
final floatingButtonPositionProvider = StateProvider<Offset>((ref) {
  return const Offset(20, 100); // Change X and Y coordinates
});
```

### 2. Customize AI Behavior
Edit `lib/providers/chatbot_provider.dart` lines 70-76 to modify the AI's context:
```dart
_chatSession = _model!.startChat(history: [
  Content.text(
    'Your custom instructions here...'
  ),
  // ...
]);
```

### 3. Adjust AI Parameters
Edit `lib/providers/chatbot_provider.dart` lines 54-59:
```dart
generationConfig: GenerationConfig(
  temperature: 0.7,    // 0.0-1.0: Lower = more focused, Higher = more creative
  topK: 40,           // Limits vocabulary selection
  topP: 0.95,         // Nucleus sampling
  maxOutputTokens: 1024,  // Maximum response length
),
```

### 4. Change Button Appearance
Edit `lib/widgets/floating_chat_button.dart` lines 64-82 to change colors, size, or icon.

---

## Troubleshooting

### ❌ "Please configure your Gemini API key"
**Solution**: Make sure you've replaced `YOUR_GEMINI_API_KEY_HERE` with your actual API key.

### ❌ "Failed to initialize Gemini AI"
**Solution**: 
- Check your internet connection
- Verify the API key is correct
- Ensure you've enabled the Gemini API in your Google Cloud project

### ❌ API quota exceeded
**Solution**: 
- Gemini API has free tier limits
- Check your usage at: https://makersuite.google.com/
- Consider upgrading if needed

### ❌ Button not showing
**Solution**: 
- Make sure you've run `flutter pub get`
- Restart the app completely
- Check that `FloatingChatButton` is added to `main.dart`

### ❌ Responses are slow
**Solution**:
- This is normal for free tier
- Gemini API processes requests in queue
- Paid tier offers faster responses

---

## Security Best Practices

### ✅ DO:
- Keep your API key in environment variables for production
- Use API key restrictions in Google Cloud Console
- Monitor API usage regularly
- Implement rate limiting if needed

### ❌ DON'T:
- Commit API keys to version control
- Share API keys publicly
- Use the same key across multiple apps
- Ignore quota warnings

### Recommended: Use Environment Variables

For production, create a `.env` file (add to `.gitignore`):
```
GEMINI_API_KEY=your_actual_key_here
```

Then modify the provider to read from environment:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

// In _initializeGemini()
final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
```

---

## API Limits & Pricing

### Free Tier (Gemini API)
- **Rate Limit**: 60 requests per minute
- **Daily Limit**: Varies by region
- **Features**: Full Gemini Pro access
- **Cost**: FREE

### For Production Use
Consider Google AI Platform with:
- Higher rate limits
- Better SLA
- Advanced analytics
- Priority support

Check current pricing: https://ai.google.dev/pricing

---

## Testing the Chatbot

### Good Test Questions:
1. "Hello, who are you?"
2. "What can you help me with?"
3. "How do I check my attendance at KIIT?"
4. "When are the next events?"
5. "Tell me about fee payment options"
6. "What is the academic calendar?"

### Expected Behavior:
- Quick welcome message on first open
- Responses in 2-5 seconds
- Context-aware answers about KIIT
- Friendly, concise responses
- Clear error messages if something fails

---

## Additional Resources

- **Gemini API Docs**: https://ai.google.dev/docs
- **Flutter Riverpod**: https://riverpod.dev/
- **Google AI Studio**: https://aistudio.google.com/

---

## Support & Issues

If you encounter issues:
1. Check the troubleshooting section above
2. Review the Gemini API documentation
3. Check Flutter logs for error messages
4. Verify all dependencies are correctly installed

---

## Future Enhancements (Optional)

- [ ] Add voice input/output
- [ ] Implement chat history persistence
- [ ] Add typing indicators
- [ ] Support for images/files
- [ ] Multi-language support
- [ ] Analytics and usage tracking
- [ ] User feedback system
- [ ] Quick reply suggestions

---

**Created for**: KIIT Student Management App  
**Last Updated**: October 23, 2025  
**Version**: 1.0.0
