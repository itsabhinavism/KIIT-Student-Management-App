import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/floating_chat_button.dart';
import '../student/student_home_screen.dart';
import '../student/student_attendance_screen.dart';
import '../full_schedule_screen.dart';
import '../teacher/teacher_home_screen.dart';
import '../teacher/teacher_attendance_screen.dart';
import '../chat/chat_list_screen.dart';

/// MainAppShell: Role-based navigation shell
/// Shows different tabs for students vs teachers
class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _selectedIndex = 0;

  // Student screens: Home, Schedule, Attendance, Messages
  final List<Widget> _studentScreens = [
    const StudentHomeScreen(),
    const FullScheduleScreen(),
    const StudentAttendanceScreen(),
    const ChatListScreen(),
  ];

  // Teacher screens: Home, Schedule, Attendance, Messages
  final List<Widget> _teacherScreens = [
    const TeacherHomeScreen(),
    const FullScheduleScreen(),
    const TeacherAttendanceScreen(),
    const ChatListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    if (user == null) {
      // Should not happen, but handle gracefully
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isStudent = user.role == 'student';
    final screens = isStudent ? _studentScreens : _teacherScreens;

    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: screens,
          ),
          // Show floating AI button only for students
          if (isStudent) const FloatingChatButton(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        items: isStudent
            ? const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month),
                  label: 'Schedule',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code),
                  label: 'Attendance',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline),
                  label: 'Messages',
                ),
              ]
            : const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month),
                  label: 'Schedule',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code_scanner),
                  label: 'Attendance',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline),
                  label: 'Messages',
                ),
              ],
      ),
    );
  }
}
