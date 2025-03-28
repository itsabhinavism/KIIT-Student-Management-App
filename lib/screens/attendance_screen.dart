import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  final Map<String, dynamic> student = {
    'name': 'Abhinav Anand',
    'rollNumber': 22053001,
    'department': 'Computer Science',
    'semester': '5th',
    'totalClasses': 100,
    'attendedClasses': 85,
    'attendancePercentage': 85.0,
  };

  final List<Map<String, dynamic>> subjects = [
    {
      'name': 'Data Structures',
      'attended': 18,
      'total': 20,
    },
    {
      'name': 'Algorithms',
      'attended': 15,
      'total': 20,
    },
    {
      'name': 'Database Systems',
      'attended': 20,
      'total': 20,
    },
    {
      'name': 'Operating Systems',
      'attended': 17,
      'total': 20,
    },
    {
      'name': 'Computer Networks',
      'attended': 19,
      'total': 20,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final percentage = student['attendancePercentage'] as double;
    final attendanceColor = percentage >= 75
        ? Colors.green
        : percentage >= 50
            ? Colors.orange
            : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Attendance'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Student Profile Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 40),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      student['name'],
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Roll No: ${student['rollNumber']}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${student['department']} • ${student['semester']} Semester',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Attendance Summary Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAttendanceStat(
                          context,
                          'Total Classes',
                          student['totalClasses'].toString(),
                          Icons.calendar_today,
                        ),
                        _buildAttendanceStat(
                          context,
                          'Attended',
                          student['attendedClasses'].toString(),
                          Icons.check_circle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey[200],
                        color: attendanceColor,
                        minHeight: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Attendance Percentage',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: attendanceColor,
                              ),
                        ),
                      ],
                    ),
                    if (percentage < 75)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          '⚠️ You need ${(75 - percentage).toStringAsFixed(1)}% more attendance to reach 75%',
                          style: TextStyle(color: Colors.orange[800]),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Subject-wise Attendance
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subject-wise Attendance',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    ...subjects.map((subject) {
                      final percent = (subject['attended'] / subject['total']) * 100;
                      final color = percent >= 75
                          ? Colors.green
                          : percent >= 50
                              ? Colors.orange
                              : Colors.red;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  subject['name'],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  '${percent.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: percent / 100,
                                backgroundColor: Colors.grey[200],
                                color: color,
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${subject['attended']} of ${subject['total']} classes attended',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceStat(
      BuildContext context, String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
