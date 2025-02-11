import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.attach_money,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Fees',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Add your fees data display here
            // Example:
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Total Fees: ₹1,00,000'),
                  Text('Fees Paid: ₹80,000'),
                  Text('Fees Due:₹20,000'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

