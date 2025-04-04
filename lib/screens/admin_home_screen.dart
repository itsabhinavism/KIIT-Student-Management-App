import 'package:flutter/material.dart';
import 'admin_attendance_screen.dart';
import 'admin_fees_screen.dart';
import 'login_screen.dart'; // Assuming you have a login screen

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
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
              height: 150, // Increased height
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
              height: 150, // Increased height
            ),
            const SizedBox(height: 40), // Added space before Logout
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout,
                  color: Colors.white), // Set icon color to white
              label: const Text("Logout",
                  style: TextStyle(
                      color: Colors.white)), // Set text color to white
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700, // Logout button color
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
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
    double height = 120, // Default height
  }) {
    return SizedBox(
      // Use SizedBox to control the height
      height: height,
      width: double.infinity, // Make the card take full width
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
                Icon(icon, size: 50, color: color), // Increased icon size
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold), // Increased text size
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
