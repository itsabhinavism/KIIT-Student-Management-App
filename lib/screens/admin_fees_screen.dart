import 'package:flutter/material.dart';
import 'dart:math';

class AdminFeesScreen extends StatelessWidget {
  const AdminFeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    List<Map<String, String>> students = List.generate(50, (index) {
      String rollNumber = '220530${index.toString().padLeft(2, '0')}';
      int totalFees = 225000;
      int feesPaid;

      if (index % 10 == 0) {
        feesPaid = totalFees; // Fully paid
      } else if (index % 9 == 0) {
        feesPaid = 0; // Fully due
      } else {
        feesPaid = random.nextInt(totalFees ~/ 2) + (totalFees ~/ 4);
      }
      int feesDue = totalFees - feesPaid;

      return {
        'rollNumber': rollNumber,
        'semesterFees': '₹$totalFees',
        'feesPaid': '₹$feesPaid',
        'feesDue': '₹$feesDue',
      };
    });

    return Scaffold(
      appBar: AppBar(title: Text('Fees Details')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.green.shade100],
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 3,
          ),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Roll No: ${student['rollNumber']}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Semester Fees: ${student['semesterFees']}'),
                    Text('Fees Paid: ${student['feesPaid']}'),
                    Text('Fees Due: ${student['feesDue']}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
