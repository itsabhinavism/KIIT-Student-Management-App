# 📚 KIIT Student Management App

A comprehensive, modern student management system designed specifically for KIIT University. This full-stack application streamlines academic operations, attendance tracking, communication, and student services with AI-powered features. 🚀

---

## 🌟 Key Highlights

- 🎓 **Role-Based Access**: Separate interfaces for Students, Teachers, and Administrators
- 🤖 **AI-Powered Assistant**: Built-in chatbot with file analysis capabilities
- 📱 **Real-Time Features**: Live attendance tracking with QR codes and geolocation
- 💬 **Integrated Messaging**: Direct student-teacher communication system
- 🎨 **Modern UI/UX**: Beautiful, responsive design with dark mode support
- 🔒 **Secure & Scalable**: JWT authentication with Row Level Security (RLS)

---

## 📋 Complete Feature List

### 🎓 For Students

#### 📊 Dashboard & Overview

- **Personalized Home Screen**: Welcome message with user profile and quick stats
- **Today's Schedule**: View all classes for the current day with time, location, and instructor
- **Attendance Summary**: Real-time attendance percentage across all enrolled courses
- **Fee Status**: Outstanding fees, payment history, and upcoming due dates
- **Quick Actions**: One-tap access to frequently used features

#### 📅 Academic Management

- **Full Weekly Schedule**:
  - Complete timetable view for all days
  - Course details with codes, names, and credits
  - Instructor information and room numbers
  - Organized by day and time slots
- **Course Enrollment**:
  - Browse available sections
  - View course information (branch, year, instructor)
  - Self-enrollment capability
  - Track enrolled courses
- **Grade Tracking**:
  - Semester-wise SGPA display
  - Letter grades for each course
  - Course-by-course performance breakdown
  - Historical grade records

#### ✅ Attendance System

- **QR Code Scanning**:
  - Scan teacher-generated QR codes to mark attendance
  - Real-time validation with location verification
  - Prevents duplicate marking
  - Expiry checking (codes valid for 5 minutes)
- **Geolocation Verification**:
  - Ensures student is within 100 meters of classroom
  - Prevents proxy attendance
  - Automatic location detection
- **Attendance Analytics**:
  - Course-wise attendance percentage
  - Total classes and attended classes count
  - Visual indicators for attendance status
  - History of attendance records

#### 💰 Fee Management

- **Comprehensive Fee Tracking**:
  - Semester-wise fee breakdown
  - Payment history with transaction IDs
  - Status indicators (Paid, Partial, Due, Overdue)
  - Total outstanding amount
  - Next due date alerts
- **Fee Details**:
  - Tuition fees breakdown
  - Additional charges itemization
  - Payment date tracking
  - Downloadable receipts ready

#### 💬 Communication

- **Student-Teacher Chat**:
  - Direct messaging with course instructors
  - Real-time message delivery
  - Chat history persistence
  - Contact list of all teaching faculty
  - Initiate conversations easily
- **Notice Board**:
  - Global university announcements
  - Section-specific notices
  - Event notifications
  - Registration links for events
  - Categorized by type (Notice/Event)

### 👨‍🏫 For Teachers

#### 🏠 Teacher Dashboard

- **Daily Schedule View**: Today's classes with section and course details
- **Quick Stats**: Classes today, total sections teaching
- **Student Management**: Access to enrolled students per section

#### 📍 Attendance Management

- **QR Code Generation**:
  - Generate unique QR codes for each class session
  - Automatic expiry after 5 minutes
  - Location-based validation
  - Real-time attendance tracking
- **Session Control**:
  - Start attendance sessions for specific courses
  - Select section and course
  - Monitor student check-ins
  - Session status tracking

#### 📢 Notice Creation

- **Section-Specific Announcements**:
  - Create notices for teaching sections
  - Event creation with registration links
  - Rich text descriptions
  - Type categorization (Notice/Event)
  - Automatic distribution to enrolled students

#### 💬 Student Communication

- **Direct Messaging**:
  - Respond to student queries
  - Maintain conversation history
  - Real-time message notifications

### 🤖 AI-Powered Features

#### 💡 Intelligent Chatbot

- **Natural Language Understanding**:
  - Ask questions in plain English
  - Context-aware responses
  - Multi-turn conversations
  - Conversation history
- **Academic Tools**:
  - **Attendance Queries**: "What's my attendance percentage?"
  - **Fee Information**: "How much fees do I owe?"
  - **Grade Lookup**: "Show me my SGPA"
  - **Schedule Queries**: "What classes do I have on Monday?"
  - **Time-based Queries**: "What's my next class?"
- **Web Search Integration**:
  - Real-time web search using Tavily API
  - Get latest information on events, holidays
  - University-related queries
  - General knowledge questions
- **Multi-Modal Input**:
  - **Image Upload**: Analyze images, diagrams, screenshots
  - **PDF Upload**: Extract and analyze document content
  - **Mixed Input**: Combine text + images in one query
  - Supported formats: JPG, PNG, GIF, PDF
- **Smart Features**:
  - Automatic tool selection based on query
  - Formatted responses (Markdown support)
  - Error handling with graceful fallbacks
  - Rich UI with syntax highlighting

#### 📄 AI Resume Reviewer

- **Intelligent Resume Analysis**:
  - Upload PDF resumes
  - AI-powered review using Google Gemini
  - Professional feedback generation
- **Detailed Feedback**:
  - One-sentence summary
  - Three specific strengths
  - Three actionable improvements
  - Markdown-formatted output
- **Features**:
  - PDF text extraction
  - Career coaching insights
  - Engineering-focused analysis
  - Instant results

### 🔐 Authentication & Security

- **Secure Login System**:
  - Email and password authentication
  - JWT token-based sessions
  - Secure token storage
  - Auto-login persistence
- **Role-Based Access Control**:
  - Student, Teacher, Admin roles
  - Route-level permission checks
  - Feature access restrictions
  - Database Row Level Security (RLS)
- **Data Protection**:
  - Encrypted passwords
  - Secure API endpoints
  - Authorization headers
  - Session management

### 🎨 User Experience

#### 🌓 Theme Support

- **Dark Mode**:
  - Full dark mode implementation
  - Smooth theme transitions
  - Eye-friendly colors
  - Persistent theme preference
- **Light Mode**:
  - Clean, bright interface
  - High contrast for readability
  - Professional appearance

#### 📱 Responsive Design

- **Cross-Platform Support**:
  - Android native app
  - iOS compatibility
  - Web application (kiitsap.netlify.app)
  - Consistent experience across devices
- **Adaptive UI**:
  - Mobile-optimized layouts
  - Tablet-friendly views
  - Desktop web interface
  - Responsive components

#### 🎯 Navigation

- **Intuitive Interface**:
  - Bottom navigation bar
  - Drawer menu with quick links
  - Breadcrumb navigation
  - Back navigation support
- **Quick Access**:
  - Floating action buttons
  - Shortcuts to common tasks
  - Search functionality
  - Context menus

### 🔄 Real-Time Features

- **Live Updates**:
  - Pull-to-refresh on all screens
  - Auto-refresh capabilities
  - Real-time chat messages
  - Instant notifications
- **Sync Status**:
  - Loading indicators
  - Progress feedback
  - Error handling with retry
  - Offline mode awareness

### 📊 Data Visualization

- **Charts & Graphs**:
  - Attendance percentage indicators
  - Fee payment progress
  - Grade distribution (ready)
  - Performance trends
- **Visual Feedback**:
  - Color-coded statuses
  - Icon indicators
  - Progress bars
  - Status badges

### 🛠️ Developer Features

- **Clean Architecture**:
  - Provider state management
  - Separation of concerns
  - Reusable components
  - Modular codebase
- **API Integration**:
  - RESTful API design
  - Standardized endpoints
  - Error handling
  - Response formatting
- **Database Design**:
  - Normalized schema
  - Efficient queries
  - RPC functions for complex logic
  - Optimized joins

---

## 🖥️ Technologies Used

### Frontend (Flutter)

- **Dart** (74.7%) - Primary language
- **Flutter Framework** - UI toolkit
- **Provider** - State management
- **HTTP** - API communication
- **Supabase Flutter** - Backend integration

### Backend (Node.js/TypeScript)

- **Hono.js** - Web framework
- **TypeScript** - Type-safe development
- **Bun** - Runtime environment
- **Supabase** - Database & Authentication
- **PostgreSQL** - Relational database

### AI & ML

- **Google Gemini AI** - LLM (gemini-2.5-flash, gemini-2.0-flash-exp)
- **Tavily API** - Web search integration
- **AI SDK by Vercel** - AI orchestration
- **pdf-parse** - PDF text extraction

### Notifications (Firebase)

This app integrates Firebase Cloud Messaging on the client to deliver notice/alert notifications. Backend data/storage remains on Supabase; Firebase is used only for push delivery.

- Firebase Core + Firebase Messaging on Android
- Foreground notifications rendered via flutter_local_notifications
- Background/terminated delivery handled by FCM
- Token generation and registration hooks (ready to send token to backend)
- Works with Firebase Console sends (incl. scheduled)

Code map
- `lib/main.dart` – `Firebase.initializeApp` and FCM bootstrap
- `lib/firebase_msg.dart` – permission request, token fetch, foreground/background handlers, local notifications
- `android/app/src/main/AndroidManifest.xml` – notification permissions (`POST_NOTIFICATIONS` for Android 13+)
- `android/app/build.gradle.kts` – core library desugaring enabled for local notifications

Quick setup (fresh clone)
1. Create a Firebase project and enable Cloud Messaging
2. Add your Android app (match `applicationId` in `android/app/build.gradle.kts`)
3. Download `google-services.json` → place in `android/app/`
4. Run `flutter pub get` and launch on a device

Testing
- Run once to register an FCM token (visible in debug console)
- In Firebase Console → Cloud Messaging → New message → target the app or specific token
- Foreground: shown via local notifications; Background/terminated: shown by system tray

### Infrastructure

- **Railway** - Backend hosting (Production)
- **Netlify** - Web app hosting
- **Supabase Cloud** - Database & Auth hosting
- **Git** - Version control

### Additional Technologies

- **JWT** - Authentication tokens
- **Row Level Security (RLS)** - Database security
- **QR Code Generation** - Attendance system
- **Mobile Scanner** - QR code scanning
- **Geolocator** - Location services
- **File Picker** - Document selection
- **GPT Markdown** - Rich text rendering

---

## 🚀 Live Demo

➡️ **Web Application**: [https://kiitsap.netlify.app/](https://kiitsap.netlify.app/)  
➡️ **API Backend**: [https://kiit-sma-backend-production.up.railway.app](https://kiit-sma-backend-production.up.railway.app)

### Demo Credentials


Student:
Email: 22052611@kiit.ac.in
Password: abcdef

Teacher:
Email: demo.teacher@kiit.ac.in
Password: STRONGpass2025

---

## 📦 Installation & Setup

### Prerequisites

- Flutter SDK (>=3.4.3)
- Bun or Node.js (for backend)
- Supabase account
- Google AI API key
- Tavily API key

### Frontend Setup

```bash
cd KIIT-Student-Management-App
flutter pub get
flutter run
```

### Backend Setup

```bash
cd kiit-sma-backend
bun install
# Create .env file with required keys
bun run dev
```

### Environment Variables

```env
# Backend (.env)
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_key
GOOGLE_GENERATIVE_AI_API_KEY=your_gemini_key
TAVILY_API_KEY=your_tavily_key

# Frontend (.env)
API_BASE_URL=https://kiit-sma-backend-production.up.railway.app/api/v1
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
```

---

## 🏗️ Project Structure

```
KIIT-Student-Management-App/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── config/                   # Configuration files
│   ├── models/                   # Data models
│   ├── providers/                # State management
│   ├── screens/                  # UI screens
│   │   ├── auth/                 # Login, Signup
│   │   ├── student/              # Student features
│   │   ├── teacher/              # Teacher features
│   │   ├── chat/                 # Messaging
│   │   ├── chatbot/              # AI Assistant
│   │   └── notices/              # Announcements
│   ├── services/                 # API services
│   └── widgets/                  # Reusable components

kiit-sma-backend/
├── src/
│   ├── index.ts                  # Server entry
│   ├── routes/                   # API endpoints
│   │   ├── ai.ts                 # AI features
│   │   ├── attendance.ts         # Attendance system
│   │   ├── chat.ts               # Messaging
│   │   ├── fees.ts               # Fee management
│   │   ├── grades.ts             # Grades
│   │   ├── notices.ts            # Notices
│   │   ├── schedule.ts           # Timetable
│   │   └── users.ts              # User management
│   ├── middlewares/              # Auth middleware
│   └── types/                    # TypeScript types
```

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 API Documentation

### Base URL

```
Production: https://kiit-sma-backend-production.up.railway.app/api/v1
Development: http://localhost:3000/api/v1
```

### Key Endpoints

#### Authentication

- `POST /auth/signup` - Create new account
- `POST /auth/login` - User login
- `GET /users/me` - Get current user

#### Student Features

- `GET /attendance/summary` - Attendance overview
- `POST /attendance/scan` - Mark attendance
- `GET /fees` - Fee details
- `GET /grades` - Academic grades
- `GET /schedule/today` - Today's classes
- `GET /schedule/full` - Full timetable

#### Teacher Features

- `POST /attendance/session` - Generate QR code
- `POST /notices` - Create announcements
- `GET /teacher/my-sections` - Teaching sections

#### AI Features

- `POST /ai/chat` - AI chatbot (supports file upload)
- `POST /ai/review-resume` - Resume analysis

#### Communication

- `GET /chat/rooms` - Chat rooms
- `POST /chat/initiate` - Start conversation
- `GET /chat/rooms/:roomId/messages` - Message history

---

## 🔒 Security Features

- ✅ JWT-based authentication
- ✅ Row Level Security (RLS) in database
- ✅ Role-based access control
- ✅ Encrypted password storage
- ✅ Secure API endpoints
- ✅ Geolocation verification
- ✅ QR code expiry mechanism
- ✅ CORS protection
- ✅ Input validation
- ✅ SQL injection prevention

---

## 📱 Supported Platforms

- ✅ Android (Native)
- ✅ iOS (Compatible)
- ✅ Web (Progressive Web App)
- ⏳ Windows Desktop (Planned)
- ⏳ macOS Desktop (Planned)

---

## 🎯 Roadmap

- [ ] Push notifications
- [ ] Offline mode support
- [ ] Exam schedule module
- [ ] Library management
- [ ] Hostel management
- [ ] Transport tracking
- [ ] Parent portal
- [ ] Assignment submission
- [ ] Video lectures integration
- [ ] Analytics dashboard

---

## 📸 Screenshots

> _Screenshots coming soon_

---

## 👥 Team

- **Abhinav** - Full Stack Developer
- **Debsoomonto** - Backend Developer
- **Shreemant** - Frontend Developer
- **Shashwat** - UI/UX Designer

---

## 📜 License

This project is licensed under the **GNU GPLv3 License** - see the [LICENSE](LICENSE) file for details.

### License Requirements

Any derivative work must be:

- ✅ Open source
- ✅ Licensed under GPLv3
- ✅ Include original copyright notice
- ✅ Disclose source code
- ✅ State significant changes

---

## 🙏 Acknowledgments

- KIIT University for inspiration
- Google Gemini AI for AI capabilities
- Supabase for backend infrastructure
- Vercel AI SDK for AI orchestration
- Flutter community for amazing packages
- All contributors and testers

---

## 📞 Support & Contact

- **Issues**: [GitHub Issues](https://github.com/itsabhinavism/KIIT-Student-Management-App/issues)
- **Email**: support@kiitsap.app
- **Website**: [kiitsap.netlify.app](https://kiitsap.netlify.app)

---

## ⭐ Show Your Support

If you find this project helpful, please consider:

- ⭐ Starring the repository
- 🍴 Forking for your own use
- 🐛 Reporting bugs
- 💡 Suggesting new features
- 📢 Sharing with others

---

**Made with ❤️ for KIIT University Students**

