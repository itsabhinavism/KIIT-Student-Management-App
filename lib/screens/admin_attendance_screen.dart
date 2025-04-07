import 'package:flutter/material.dart';
import 'dart:math';

class StudentAttendanceScreen extends StatelessWidget {
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

  Color getAttendanceColor(double percentage) {
    if (percentage >= 75) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          double percentage = double.parse(student['attendancePercentage']);
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: getAttendanceColor(percentage),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Roll No: ${student['rollNumber']}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 6),
                        Text('Total Classes: ${student['totalClasses']}'),
                        Text('Classes Attended: ${student['attendedClasses']}'),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              'Attendance: ',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${student['attendancePercentage']}%',
                              style: TextStyle(
                                color: getAttendanceColor(percentage),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            getAttendanceColor(percentage),
                          ),
                          minHeight: 6,
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
