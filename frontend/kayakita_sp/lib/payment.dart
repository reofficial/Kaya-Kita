import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: paymentHistory.length,
              itemBuilder: (context, index) {
                final payment = paymentHistory[index];
                return ListTile(
                  leading: Icon(Icons.payment, color: Colors.green),
                  title: Text(payment['recipient'] ?? 'Unknown'),
                  subtitle: Text(payment['date'] ?? ''),
                  trailing: Text(
                    payment['amount'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () {
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
              },
              child: Text("Request transaction history."),
            ),
          ),
        ],
      ),
    );
  }
}

List<Map<String, String?>> paymentHistory = [
  {
    "recipient": "Alice Johnson",
    "amount": "P50.00",
    "date": "July 10, 2025"
  },
  {
    "recipient": "Bob Smith",
    "amount": "P120.00",
    "date": "July 5, 2025"
  },
  {
    "recipient": "Charlie Brown",
    "amount": "P75.00",
    "date": "July 2, 2025"
  },
];
