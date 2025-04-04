import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'academic_report.dart';
import 'attendance_screen.dart';
import 'events_screen.dart';
import 'fees_screen.dart';
import 'login_screen.dart';
import 'timetable_screen.dart';
import '../providers/theme_provider.dart';

// Add a provider for offline mode
final offlineModeProvider = StateProvider<bool>((ref) => false);

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    AttendanceScreen(),
    FeesScreen(),
    AcademicReportScreen(),
    EventsScreen(),
    TimeTableScreen(),
  ];

  final List<Color> _appBarColors = [
    Colors.lightBlue.shade900,
    Colors.green.shade900,
    Colors.orange.shade900,
    Colors.red.shade900,
    Colors.purple.shade900,
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

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About KIIT Student Management App'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'KIIT Student Management App',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Version: 1.0.0'),
                const SizedBox(height: 20),
                SelectableText(
                  'A Mini Project made by Abhinav Anand, Debsoomonto Sen, Shashwat Sinha and Shreemant Sahu '
                  'under the guidance of Ms. Namita Panda. The KIIT Portal Mobile App aims to transform the '
                  'existing SAP portal into a user-friendly mobile application for students and faculty. '
                  'By integrating academic, administrative, and financial functionalities into a single platform, '
                  'the app streamlines daily workflows, enhances accessibility, and improves engagement across '
                  'the university community.',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _toggleOfflineMode(bool value) {
    // Show a confirmation dialog if enabling offline mode
    if (value) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enable Offline Mode?'),
            content: const Text(
              'In offline mode, the app will use locally cached data. Some features may be limited or unavailable.',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Enable'),
                onPressed: () {
                  ref.read(offlineModeProvider.notifier).state = true;
                  Navigator.of(context).pop();
                  
                  // Show confirmation snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Offline mode enabled'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      // Directly disable offline mode
      ref.read(offlineModeProvider.notifier).state = false;
      
      // Show confirmation snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Offline mode disabled'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider) == AppTheme.dark;
    final isOfflineMode = ref.watch(offlineModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KIIT Portal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _appBarColors[_selectedIndex],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          //if (isOfflineMode)
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Image.asset(
                          'assets/KIIT.png',
                          width: 40,
                          height: 40,
                        ),
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: _appBarColors[_selectedIndex],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Abhinav Anand',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Roll Number: 22052611',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Offline Mode Toggle
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
            // Dark Mode Toggle
            ListTile(
              leading: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: _appBarColors[_selectedIndex],
              ),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: isDarkMode,
                activeColor: _appBarColors[_selectedIndex],
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),
            ),
            // About Section
            ListTile(
              leading: Icon(
                Icons.info,
                color: _appBarColors[_selectedIndex],
              ),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: _appBarColors[_selectedIndex],
              ),
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
          ],
        ),
      ),
    );
  }
}