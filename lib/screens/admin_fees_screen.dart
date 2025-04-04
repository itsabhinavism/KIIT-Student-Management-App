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
        feesPaid = totalFees;
      } else if (index % 9 == 0) {
        feesPaid = 0;
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
      appBar: AppBar(
        title: const Text('Fees Details'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.green.shade100],
          ),
        ),
        child: GridView.builder(
          itemCount: students.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.2, 
          ),
          itemBuilder: (context, index) {
            final student = students[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        '🎓 Roll No: ${student['rollNumber']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('💵 Fees: ${student['semesterFees']}', style: const TextStyle(fontSize: 13)),
                    Text('✅ Paid: ${student['feesPaid']}', style: const TextStyle(fontSize: 13)),
                    Text('❗ Due: ${student['feesDue']}', style: const TextStyle(fontSize: 13)),
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
