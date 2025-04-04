import 'package:flutter/material.dart';
import 'academic_report.dart';
import 'attendance_screen.dart';
import 'events_screen.dart';
import 'fees_screen.dart';
import 'qr_code_scanner.dart';
import 'settings_screen.dart';
import 'login_screen.dart';
import 'timetable_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    AttendanceScreen(),
    FeesScreen(),
    AcademicReportScreen(),
    EventsScreen(),
    TimeTableScreen(),
  ];

  final List<Color> _appBarColors = [
    Colors.lightBlue.shade900, // Attendance
    Colors.green.shade900,     // Fees
    Colors.orange.shade900,    // Academic Report
    Colors.red.shade900,       // Events
    Colors.purple.shade900,    // Timetable (updated to purple)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) {
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
        backgroundColor: _appBarColors[_selectedIndex],
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
                  colors: [
                    _appBarColors[_selectedIndex],
                    _appBarColors[_selectedIndex].withOpacity(0.7),
                  ],
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
              leading: Icon(Icons.settings, color: _appBarColors[_selectedIndex]),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: _appBarColors[_selectedIndex]),
              title: const Text('Log'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: _appBarColors[_selectedIndex]),
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: _appBarColors[_selectedIndex]),
              title: const Text('Logout'),
              onTap: () {
                _logout(context);
              },
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
              backgroundColor: Colors.purple.shade900, // Updated to purple
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _appBarColors[_selectedIndex],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScannerScreen()),
          );
        },
        child: const Icon(Icons.qr_code),
      ),
    );
  }
}
