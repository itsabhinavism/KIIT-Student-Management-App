// Academic Report Screen
import 'package:flutter/material.dart';

class AcademicReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 100,
              color: Colors.orange,
            ),
            SizedBox(height: 20),
            Text(
              'Academic Report',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Add your academic report data display here
            // Example:
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Semester: 1'),
                  Text('GPA: 8.5'),
                  Text('Subjects: 5'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
