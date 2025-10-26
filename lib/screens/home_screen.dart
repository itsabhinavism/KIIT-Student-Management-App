import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'academic_report.dart';
import 'attendance_screen.dart';
import 'events_screen.dart';
import 'fees_screen.dart';
import 'login_screen.dart';
import 'timetable_screen.dart';
import 'qr_scanner_screen.dart';
import 'faculty_support_screen.dart';
import '../providers/theme_provider.dart';
import '../providers/chatbot_provider.dart';
import '../providers/event_provider.dart';

class OfflineModeNotifier extends ChangeNotifier {
  bool _isOffline = false;

  bool get isOffline => _isOffline;

  void setOfflineMode(bool value) {
    _isOffline = value;
    notifyListeners();
  }
}

class HomeScreen extends StatefulWidget {
  final String rollNumber;

  const HomeScreen({super.key, required this.rollNumber});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final Map<String, String> _profileMap = {
    '22051624': 'assets/shreemant.jpg',
    '2205896': 'assets/KIIT.png',
    '22052611': 'assets/abhinav.jpg',
    '22053018': 'assets/shashwat.jpg',
  };

  String studentName = 'Loading...';
  String studentRollNumber = '';
  String? profileImageAsset;

  late final List<Widget> _screens = [
    AttendanceScreen(rollNumber: widget.rollNumber),
    QRScannerScreen(rollNumber: widget.rollNumber),
    FeesScreen(rollNumber: widget.rollNumber),
    const AcademicReportScreen(),
    EventsScreen(rollNumber: widget.rollNumber),
    TimeTableScreen(),
  ];

  final List<Color> _appBarColors = [
    Colors.lightBlue.shade900,
    Colors.indigo.shade900,
    Colors.green.shade900,
    Colors.orange.shade900,
    Colors.red.shade900,
    Colors.purple.shade900,
  ];

  @override
  void initState() {
    super.initState();
    _loadStudentData();
    _updateChatbotContext();
  }

  void _updateChatbotContext() {
    // Gather comprehensive app data from ALL tabs and update chatbot context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatbot = context.read<ChatBotNotifier>();
      final events = context.read<EventNotifier>().events;
      
      // COMPREHENSIVE DATA - Matches actual UI shown to user
      final contextData = {
        'rollNumber': widget.rollNumber,
        'studentName': studentName,
        
        // ATTENDANCE DATA (from Attendance Tab)
        'attendance': {
          'overall': 89.0,
          'totalClasses': 100,
          'classesAttended': 89,
          'classesAbsent': 11,
          'semester': '5th Semester',
          'department': 'Computer Science',
          'subjects': {
            'Data Structures': {
              'percentage': 75.0,
              'attended': 15,
              'total': 20,
              'absent': 5,
            },
            'Algorithms': {
              'percentage': 95.0,
              'attended': 19,
              'total': 20,
              'absent': 1,
            },
            'Database Systems': {
              'percentage': 90.0,
              'attended': 18,
              'total': 20,
              'absent': 2,
            },
            'Operating Systems': {
              'percentage': 90.0,
              'attended': 18,
              'total': 20,
              'absent': 2,
            },
            'Computer Networks': {
              'percentage': 95.0,
              'attended': 19,
              'total': 20,
              'absent': 1,
            },
          }
        },
        
        // FEES DATA (from Fees Tab)
        'fees': {
          'totalFees': 200000,
          'paidAmount': 150000,
          'pendingAmount': 50000,
          'paymentStatus': 'Partially Paid',
          'lastPaymentDate': '2025-01-15',
          'lastPaymentAmount': 50000,
          'nextDueDate': '2025-12-31',
          'breakdown': {
            'tuitionFees': 150000,
            'hostelFees': 30000,
            'examFees': 10000,
            'libraryFees': 5000,
            'otherFees': 5000,
          },
          'paymentHistory': [
            {'date': '2025-01-15', 'amount': 50000, 'mode': 'Online'},
            {'date': '2024-08-10', 'amount': 50000, 'mode': 'Online'},
            {'date': '2024-01-05', 'amount': 50000, 'mode': 'Cheque'},
          ]
        },
        
        // ACADEMIC REPORT DATA (from Report Tab)
        'academicReport': {
          'currentSemester': 5,
          'currentCGPA': 8.5,
          'previousSemesterSGPA': 8.7,
          'semesterResults': [
            {'semester': 1, 'sgpa': 8.2, 'status': 'Pass'},
            {'semester': 2, 'sgpa': 8.4, 'status': 'Pass'},
            {'semester': 3, 'sgpa': 8.6, 'status': 'Pass'},
            {'semester': 4, 'sgpa': 8.7, 'status': 'Pass'},
          ],
          'currentSubjects': {
            'Data Structures': {'grade': 'A', 'credits': 4, 'marks': 85},
            'Algorithms': {'grade': 'A+', 'credits': 4, 'marks': 92},
            'Database Systems': {'grade': 'A', 'credits': 4, 'marks': 88},
            'Operating Systems': {'grade': 'A', 'credits': 4, 'marks': 87},
            'Computer Networks': {'grade': 'A+', 'credits': 4, 'marks': 91},
          },
          'totalCreditsCompleted': 80,
          'backlogsCount': 0,
          'rank': 'Top 10%',
        },
        
        // EVENTS DATA (from Events Tab)
        'events': events.map((e) => {
          'name': e.name,
          'date': e.date.toString().substring(0, 10),
          'category': e.category,
          'location': e.location,
          'description': e.description,
        }).toList(),
        
        // TIMETABLE DATA (from Timetable Tab)
        'timetable': {
          'todayClasses': 5,
          'todaySubjects': ['Data Structures', 'Algorithms', 'Database Systems', 'Operating Systems', 'Computer Networks'],
          'weeklySchedule': {
            'Monday': ['Data Structures 9-10AM', 'Algorithms 10-11AM', 'Database Systems 11-12PM'],
            'Tuesday': ['Operating Systems 9-10AM', 'Computer Networks 10-11AM', 'Lab 2-5PM'],
            'Wednesday': ['Data Structures 9-10AM', 'Algorithms 11-12PM', 'Database Systems 2-3PM'],
            'Thursday': ['Operating Systems 9-10AM', 'Computer Networks 10-11AM', 'Lab 2-5PM'],
            'Friday': ['Data Structures 9-10AM', 'Algorithms 10-11AM', 'Project Work 2-5PM'],
            'Saturday': ['Sports/Extra Activities'],
            'Sunday': ['Holiday'],
          },
          'nextClass': 'Data Structures at 9:00 AM',
        },
        
        // ADDITIONAL STUDENT INFO
        'personalInfo': {
          'email': '${widget.rollNumber}@kiit.ac.in',
          'phone': '+91 9876543210',
          'branch': 'Computer Science and Engineering',
          'section': 'CS-A',
          'mentor': 'Dr. Rajesh Kumar',
          'yearOfAdmission': 2022,
          'expectedGraduation': 2026,
        }
      };
      
      chatbot.updateAppContext(contextData);
    });
  }

  Future<void> _loadStudentData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('students')
          .doc(widget.rollNumber)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (!mounted) return;
        setState(() {
          studentName = data['name'] ?? 'No Name';
          studentRollNumber = data['rollNumber'] ?? widget.rollNumber;
          profileImageAsset = _profileMap[widget.rollNumber];
        });
      } else {
        if (!mounted) return;
        setState(() {
          studentName = 'Student Not Found';
          studentRollNumber = widget.rollNumber;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        studentName = 'Error fetching data';
        studentRollNumber = widget.rollNumber;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Updated logout function in home_screen.dart
  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);  // Critical logout flag update
    await prefs.setBool('isAdmin', false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        duration: Duration(seconds: 1),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    });
  }


  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('About KIIT Student Management App'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'KIIT Student Management App',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 12),
              Text('Version: 1.0.0'),
              SizedBox(height: 20),
              SelectableText(
                'A Mini Project made by Abhinav Anand, Debsoomonto Sen, '
                    'Shashwat Sinha and Shreemant Sahu under the guidance of Ms. Namita Panda. '
                    'The KIIT Portal Mobile App aims to modify and upgrade the existing KIIT SAP portal into a '
                    'user-friendly application for students and faculty that can run on versatile platforms.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _toggleOfflineMode(bool value) {
    if (value) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Enable Offline Mode?'),
          content: const Text(
              'In offline mode, the app will use locally cached data. Some features may be limited or unavailable.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Enable'),
              onPressed: () {
                context.read<OfflineModeNotifier>().setOfflineMode(true);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Offline mode enabled')),
                );
              },
            ),
          ],
        ),
      );
    } else {
      context.read<OfflineModeNotifier>().setOfflineMode(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Offline mode disabled')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final isDarkMode = themeNotifier.theme == AppTheme.dark;
    final offlineModeNotifier = context.watch<OfflineModeNotifier>();
    final isOfflineMode = offlineModeNotifier.isOffline;

    return Scaffold(
      appBar: AppBar(
        title: const Text('KIIT Portal', style: TextStyle(color: Colors.white)),
        backgroundColor: _appBarColors[_selectedIndex],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset('assets/KIIT.png', width: 40, height: 40),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: _appBarColors[_selectedIndex]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  profileImageAsset != null
                      ? CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(profileImageAsset!),
                    backgroundColor: Colors.white,
                  )
                      : const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.school, size: 35, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Roll Number: $studentRollNumber',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                isOfflineMode ? Icons.offline_bolt : Icons.offline_pin_outlined,
                color: _appBarColors[_selectedIndex],
              ),
              title: const Text('Offline Mode'),
              trailing: Switch(
                value: isOfflineMode,
                activeColor: _appBarColors[_selectedIndex],
                onChanged: _toggleOfflineMode,
              ),
            ),
            ListTile(
              leading: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: _appBarColors[_selectedIndex],
              ),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: isDarkMode,
                activeColor: _appBarColors[_selectedIndex],
                onChanged: (_) => context.read<ThemeNotifier>().toggleTheme(),
              ),
            ),
            ListTile(
              leading: Icon(Icons.support_agent, color: _appBarColors[_selectedIndex]),
              title: const Text('Faculty Support'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacultySupportScreen(
                      studentId: widget.rollNumber,
                      studentName: studentName,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: _appBarColors[_selectedIndex]),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: _appBarColors[_selectedIndex]),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          iconSize: 28,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today),
              label: 'Attendance',
              backgroundColor: Colors.lightBlue.shade900,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.qr_code_scanner),
              label: 'QR Scanner',
              backgroundColor: Colors.indigo.shade900,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.attach_money),
              label: 'Fees',
              backgroundColor: Colors.green.shade900,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.school),
              label: 'Report',
              backgroundColor: Colors.orange.shade900,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.event),
              label: 'Events',
              backgroundColor: Colors.red.shade900,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.schedule),
              label: 'Timetable',
              backgroundColor: Colors.purple.shade900,
            ),
          ],
        ),
      ),
    );
  }
}
