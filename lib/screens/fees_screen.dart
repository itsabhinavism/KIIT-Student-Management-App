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
    FeeItem(
      title: 'Development Fee',
      amount: 12000,
      status: FeeStatus.paid,
      dueDate: DateTime(2023, 10, 10),
      paymentDate: DateTime(2023, 10, 5),
    ),
    FeeItem(
      title: 'Convocation Fee',
      amount: 1500,
      status: FeeStatus.pending,
      dueDate: DateTime(2025, 3, 31),
    ),
    FeeItem(
      title: 'ID Card Replacement',
      amount: 300,
      status: FeeStatus.paid,
      dueDate: DateTime(2023, 11, 10),
      paymentDate: DateTime(2023, 11, 8),
    ),
    FeeItem(
      title: 'Backlog Exam Fee',
      amount: 2500,
      status: FeeStatus.pending,
      dueDate: DateTime(2024, 12, 5),
    ),
    FeeItem(
      title: 'Bus Fee (Semester 1)',
      amount: 6000,
      status: FeeStatus.paid,
      dueDate: DateTime(2023, 7, 1),
      paymentDate: DateTime(2023, 6, 25),
    ),
    FeeItem(
      title: 'Late Registration Fine',
      amount: 1000,
      status: FeeStatus.pending,
      dueDate: DateTime(2025, 2, 1),
    ),
  ];

  double get totalPaid => feeItems
      .where((item) => item.status == FeeStatus.paid)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalPending => feeItems
      .where((item) => item.status == FeeStatus.pending)
      .fold(0.0, (sum, item) => sum + item.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fees Information'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        color: Colors.green.shade50,
        child: Column(
          children: [
            _buildSummaryCard(),
            Expanded(
              child: ListView.builder(
                itemCount: feeItems.length,
                itemBuilder: (context, index) {
                  final fee = feeItems[index];
                  return _buildFeeCard(context, fee);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem("Total Paid", totalPaid, Colors.green),
            _buildSummaryItem("Total Pending", totalPending, Colors.red),
            _buildSummaryItem("Overall", totalPaid + totalPending, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildFeeCard(BuildContext context, FeeItem fee) {
    final isOverdue = fee.status == FeeStatus.pending &&
        fee.dueDate != null &&
        fee.dueDate!.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          fee.status == FeeStatus.paid ? Icons.check_circle : Icons.warning,
          color: fee.status == FeeStatus.paid
              ? Colors.green
              : (isOverdue ? Colors.red : Colors.orange),
          size: 32,
        ),
        title: Text(
          fee.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amount: ₹${fee.amount.toStringAsFixed(2)}'),
              Text(
                'Due Date: ${DateFormat('dd-MM-yyyy').format(fee.dueDate!)}',
                style: TextStyle(
                  color: isOverdue ? Colors.red : Colors.black87,
                  fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (fee.paymentDate != null)
                Text(
                  'Paid on: ${DateFormat('dd-MM-yyyy').format(fee.paymentDate!)}',
                  style: const TextStyle(color: Colors.green),
                ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Chip(
                    label: Text(
                      fee.status == FeeStatus.paid
                          ? 'PAID'
                          : (isOverdue ? 'OVERDUE' : 'PENDING'),
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: fee.status == FeeStatus.paid
                        ? Colors.green
                        : isOverdue
                        ? Colors.red
                        : Colors.orange,
                  ),
                  const Spacer(),
                  if (fee.status == FeeStatus.pending)
                    TextButton.icon(
                      onPressed: () {
                        // Implement pay now action
                      },
                      icon: const Icon(Icons.payment, color: Colors.blue),
                      label: const Text("Pay Now", style: TextStyle(color: Colors.blue)),
                    )
                  else
                    TextButton.icon(
                      onPressed: () {
                        // Implement receipt action
                      },
                      icon: const Icon(Icons.receipt_long, color: Colors.green),
                      label: const Text("Receipt", style: TextStyle(color: Colors.green)),
                    ),
                ],
              ),
            ],
          ),
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
