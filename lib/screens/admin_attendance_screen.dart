import 'package:flutter/material.dart';
import 'dart:math';

class AdminAttendanceScreen extends StatelessWidget {
  final List<Map<String, dynamic>> students = List.generate(50, (index) {
    int rollNumber = 22053000 + index;
    int totalClasses = 100;
    int attendedClasses = Random().nextInt(101);
    double attendancePercentage = (attendedClasses / totalClasses) * 100;

    return {
      'rollNumber': rollNumber,
      'totalClasses': totalClasses,
      'attendedClasses': attendedClasses,
      'attendancePercentage': attendancePercentage,
    };
  });

  AdminAttendanceScreen({super.key});

  Color getAttendanceColor(double percentage) {
    if (percentage >= 75) return Colors.green.shade600;
    if (percentage >= 50) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Attendance Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          final percentage = student['attendancePercentage'];
          final percentageText = "${percentage.toStringAsFixed(2)}%";
          final color = getAttendanceColor(percentage);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.2),
                    child: Icon(Icons.person, color: color),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Roll No: ${student['rollNumber']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Total Classes: ${student['totalClasses']}'),
                        Text('Attended: ${student['attendedClasses']}'),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Attendance: $percentageText',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
