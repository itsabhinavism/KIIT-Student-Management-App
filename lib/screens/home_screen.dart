import 'package:flutter/material.dart';
import 'academic_report.dart';
import 'attendance_screen.dart';
import 'events_screen.dart';
import 'fees_screen.dart';
import 'qr_code_scanner.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

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
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) {
    // Perform any logout-related tasks here (e.g., clearing tokens, etc.)// Navigate to the login screen and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()), // Replace LoginScreen() with your actual login screen widget
          (Route<dynamic> route) => false, // This condition removes all routes from the stack
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
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white), // Change the drawer icon color here
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 150, // Set the desired height
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
              leading: Icon(Icons.settings, color: Colors.blue.shade900), // Change icon color here
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()), // Navigate to settings
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.blue.shade900), // Change icon color here
              title: const Text('Log'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Add navigation to log screen here
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: Colors.blue.shade900), // Change icon color here
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Add navigation to help screen here
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.blue.shade900), // Change icon color here
              title: const Text('Logout'),
              onTap: () {
                _logout(context); // Call the logout function
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
              backgroundColor: Colors.blue.shade900,
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
              backgroundColor: Colors.purple.shade900,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
