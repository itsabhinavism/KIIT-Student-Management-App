import 'package:flutter/material.dart';
import 'dart:math';

class AttendanceScreen extends StatelessWidget {
  final List<Map<String, dynamic>> students = List.generate(50, (index) {
    int rollNumber = 22053000 + index;
    int totalClasses = 100;
    int attendedClasses = Random().nextInt(101); // Random between 0-100
    double attendancePercentage = (attendedClasses / totalClasses) * 100;

    return {
      'rollNumber': rollNumber,
      'totalClasses': totalClasses,
      'attendedClasses': attendedClasses,
      'attendancePercentage': attendancePercentage.toStringAsFixed(2),
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Details'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text('Roll No: ${student['rollNumber']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Classes: ${student['totalClasses']}'),
                  Text('Classes Attended: ${student['attendedClasses']}'),
                  Text(
                      'Attendance Percentage: ${student['attendancePercentage']}%'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
