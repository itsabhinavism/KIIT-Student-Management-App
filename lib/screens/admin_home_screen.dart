import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'admin_attendance_screen.dart';
import 'admin_fees_screen.dart';
import 'login_screen.dart';
import '../providers/theme_provider.dart';


final offlineModeProvider = StateProvider<bool>((ref) => false);

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  final List<Color> _appBarColors = [
    Colors.blue.shade900,
    Colors.green.shade700,
  ];

  int _selectedIndex = 0;

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _toggleOfflineMode(bool value) {
   
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
    
      ref.read(offlineModeProvider.notifier).state = false;

     
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Offline mode disabled'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About KIIT Admin Portal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'KIIT Admin Management App',
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
                  'under the guidance of Ms. Namita Panda. The KIIT Admin Portal Mobile App provides administrative '
                  'tools for managing student data, attendance records, fees information, and other administrative '
                  'tasks within the KIIT University system.',
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider) == AppTheme.dark;
    final isOfflineMode = ref.watch(offlineModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _appBarColors[_selectedIndex],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
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
                color: Colors.blue.shade900,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/mam.jpg',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ms. Namita Panda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'ID: ADMIN123456',
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
                color: Colors.blue.shade900,
              ),
              title: const Text('Offline Mode'),
              trailing: Switch(
                value: isOfflineMode,
                activeColor: Colors.blue.shade900,
                onChanged: _toggleOfflineMode,
              ),
            ),
            // Dark Mode Toggle
            ListTile(
              leading: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Colors.blue.shade900,
              ),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: isDarkMode,
                activeColor: Colors.blue.shade900,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),
            ),
            // About Section
            ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.blue.shade900,
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
                color: Colors.blue.shade900,
              ),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDashboardItem(
              context,
              "Attendance Details",
              Icons.calendar_today,
              Colors.blue.shade700,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminAttendanceScreen()),
                );
              },
              height: 150,
            ),
            const SizedBox(height: 20),
            _buildDashboardItem(
              context,
              "Fees Details",
              Icons.attach_money,
              Colors.green.shade700,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminFeesScreen()),
                );
              },
              height: 150,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    double height = 120,
  }) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50, color: color),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}