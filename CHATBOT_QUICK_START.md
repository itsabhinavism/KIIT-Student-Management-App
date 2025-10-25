# 🚀 Quick Start - AI Chatbot

## 3 Simple Steps to Get Started

### 1️⃣ Get API Key
Visit: https://aistudio.google.com/app/apikey
- Sign in with Google
- Click "Create API Key"
- Copy the key

### 2️⃣ Add Key to App
Open: `lib/providers/chatbot_provider.dart`
- Find line 42: `const apiKey = 'YOUR_GEMINI_API_KEY_HERE';`
- Replace with your key: `const apiKey = 'AIzaSy...';`

### 3️⃣ Run & Test
```bash
flutter pub get
flutter run
```
- Look for the blue floating button 🤖
- Tap to chat!

---

## ✨ Features

- 🎯 **Draggable** floating button
- 💬 **Full chat** interface
- 🌓 **Dark/Light** mode support
- 🤖 **AI-powered** by Gemini
- 📱 **Persistent** across all screens

---

## 🎨 UI Elements

**Floating Button**
- Blue gradient circle
- Robot icon
- Green active indicator
- Drag anywhere on screen

**Chat Screen**
- User messages (right, blue)
- AI messages (left, gray/dark)
- Timestamps
- Loading indicator
- Clear chat button
- Theme-aware colors

---

## 📝 Test Questions

Try these to test the chatbot:
- "Hello, introduce yourself"
- "How can you help KIIT students?"
- "Tell me about attendance"
- "What about fees?"
- "Upcoming events?"

---

## 🔧 Quick Customization

**Change button position**: `lib/widgets/floating_chat_button.dart` (line 12)
**Change AI behavior**: `lib/providers/chatbot_provider.dart` (line 70-76)
**Change colors**: Edit gradient colors in `floating_chat_button.dart`

---

## ⚠️ Common Issues

| Issue | Solution |
|-------|----------|
| Button not showing | Run `flutter pub get` and restart |
| "Configure API key" error | Check you replaced the placeholder key |
| Slow responses | Normal for free tier |
| No internet | Check connection |

---

## 📚 Full Documentation

See `CHATBOT_SETUP_GUIDE.md` for complete details!

---

**Need Help?** Check the troubleshooting section in the full guide.
