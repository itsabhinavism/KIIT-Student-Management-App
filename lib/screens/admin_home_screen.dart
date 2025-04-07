import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

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
              children: const [
                Text(
                  'KIIT Admin Management App',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 12),
                Text('Version: 1.0.0'),
                SizedBox(height: 20),
                SelectableText(
                  'A Mini Project made by Abhinav Anand, Debsoomonto Sen, Shashwat Sinha and Shreemant Sahu '
                      'under the guidance of Ms. Namita Panda. The KIIT Admin Portal Mobile App provides administrative '
                      'tools for managing student data, attendance records, fees information, and other administrative '
                      'tasks within the KIIT University system.',
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
      drawer: _buildDrawer(isDarkMode, isOfflineMode),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDashboardItem(
                title: "Attendance Details",
                icon: Icons.calendar_today,
                gradient: const LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
                onTap: () {
                  setState(() => _selectedIndex = 0);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => StudentAttendanceScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildDashboardItem(
                title: "Fees Details",
                icon: Icons.attach_money,
                gradient: LinearGradient(
                    colors: [Colors.green.shade700, Colors.greenAccent]),
                onTap: () {
                  setState(() => _selectedIndex = 1);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminFeesScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(bool isDarkMode, bool isOfflineMode) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.blue]),
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
          ListTile(
            leading: Icon(Icons.info, color: Colors.blue.shade900),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem({
    required String title,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
