import 'package:flutter/material.dart';

class AdminStudentDetails extends StatelessWidget {
  const AdminStudentDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select a section to manage:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: const [
                _AdminDashboardCard(
                  icon: Icons.person,
                  title: 'Students',
                ),
                _AdminDashboardCard(
                  icon: Icons.event_available,
                  title: 'Attendance',
                ),
                _AdminDashboardCard(
                  icon: Icons.payment,
                  title: 'Fees',
                ),
                _AdminDashboardCard(
                  icon: Icons.settings,
                  title: 'Settings',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminDashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _AdminDashboardCard({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to the appropriate screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title section coming soon!')),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.deepPurple),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
