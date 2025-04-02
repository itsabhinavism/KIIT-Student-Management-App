import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeesScreen extends StatelessWidget {
  FeesScreen({Key? key}) : super(key: key);

  final List<FeeItem> feeItems = [
    FeeItem(
      title: 'Tuition Fee (Semester 1)',
      amount: 50000,
      status: FeeStatus.paid,
      dueDate: DateTime(2023, 8, 15),
      paymentDate: DateTime(2023, 8, 10),
    ),
    FeeItem(
      title: 'Hostel Fee (Yearly)',
      amount: 30000,
      status: FeeStatus.paid,
      dueDate: DateTime(2023, 9, 30),
      paymentDate: DateTime(2023, 9, 20),
    ),
    FeeItem(
      title: 'Exam Fee (Semester 2)',
      amount: 10000,
      status: FeeStatus.pending,
      dueDate: DateTime(2024, 2, 28),
    ),
    FeeItem(
      title: 'Library Fine',
      amount: 500,
      status: FeeStatus.pending,
      dueDate: DateTime(2024, 1, 15),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fees Information'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        color: Colors.green.shade100,
        child: ListView.builder(
          itemCount: feeItems.length,
          itemBuilder: (context, index) {
            final fee = feeItems[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: Text(
                  fee.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount: ₹${fee.amount.toStringAsFixed(2)}'),
                    Text(
                      'Due Date: ${fee.dueDate != null ? DateFormat('dd-MM-yyyy').format(fee.dueDate!) : "N/A"}',
                    ),
                    if (fee.paymentDate != null)
                      Text(
                        'Payment Date: ${DateFormat('dd-MM-yyyy').format(fee.paymentDate!)}',
                        style: TextStyle(color: Colors.green),
                      ),
                    Text(
                      'Status: ${fee.status == FeeStatus.paid ? "Paid" : "Pending"}',
                      style: TextStyle(
                        color: fee.status == FeeStatus.paid ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

// Enum to represent fee payment status
enum FeeStatus { paid, pending }

// FeeItem model class
class FeeItem {
  final String title;
  final double amount;
  final FeeStatus status;
  final DateTime? dueDate;
  final DateTime? paymentDate;

  FeeItem({
    required this.title,
    required this.amount,
    required this.status,
    this.dueDate,
    this.paymentDate,
  });
}
