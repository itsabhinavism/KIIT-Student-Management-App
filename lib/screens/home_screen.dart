// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:sap_portal_app/screens/timetable_screen.dart';
import 'package:sap_portal_app/screens/admin_student_details.dart';
import 'academic_report.dart';
import 'attendance_screen.dart';
import 'events_screen.dart';
import 'fees_screen.dart';
import 'qr_code_scanner.dart';
import 'settings_screen.dart';
import 'login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Widget> _screens = [];bool _isAdmin = false;
  Color _appBarColor = Colors.blue.shade900; // Initial app bar color

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _isAdmin = (userDoc.data()?['role'] == 'admin') ?? false;
        _screens = _buildScreens();
      });
    } else {
      // Handle case where user is not logged in (shouldn't happen if auth is set up correctly)
      setState(() {
        _screens = _buildScreens(); // Build student screens by default
      });
    }
  }

  List<Widget> _buildScreens() {
    final studentScreens = [
      AttendanceScreen(),
      FeesScreen(),
      AcademicReportScreen(),
      EventsScreen(),TimeTableScreen(),
    ];
    final adminScreens = [...studentScreens, const AdminStudentDetails()];
    return _isAdmin ? adminScreens : studentScreens;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Update app bar color based on selected index
      switch (index) {
        case 0:
          _appBarColor = Colors.lightBlue.shade900;
          break;
        case 1:
          _appBarColor = Colors.green.shade900;
          break;
        case 2:
          _appBarColor = Colors.orange.shade900;
          break;
        case 3:
          _appBarColor = Colors.red.shade900;
          break;
        case 4:
          _appBarColor = Colors.purple.shade900;
          break;
        case 5: // Admin "Students" tab
          _appBarColor = Colors.blueGrey.shade900;
          break;
        default:
          _appBarColor = Colors.blue.shade900; // Default color
      }
    });
  }

  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KIIT Portal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _appBarColor, // Use the dynamic color
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade900, Colors.blue.shade500],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school,
                      size: 48,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'KIIT Portal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blue.shade900),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.blue.shade900),
              title: const Text('Log'),
              onTap: () {
                Navigator.pop(context);
                // Add navigation to log screen here
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: Colors.blue.shade900),
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context);
                // Add navigation to help screen here
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.blue.shade900),
              title: const Text('Logout'),
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: _screens.isNotEmpty ? _screens[_selectedIndex] : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: _screens.isNotEmpty
          ? Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),topRight: Radius.circular(20),
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
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today),
              label: 'Attendance',
              backgroundColor: Colors.lightBlue.shade900,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.attach_money),
              label: 'Fees',
              backgroundColor: Colors.green.shade900,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.school),
              label: 'Academic Report',
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
            if (_isAdmin)
              BottomNavigationBarItem(
                icon: const Icon(Icons.admin_panel_settings),
                label: 'Students',
                backgroundColor: Colors.blueGrey.shade900,
              ),
          ],
        ),
      )
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScannerScreen()),
          );
        },
        child: const Icon(Icons.qr_code),
      ),);
  }
}