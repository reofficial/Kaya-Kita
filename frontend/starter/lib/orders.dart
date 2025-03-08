import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for orders
    List<Map<String, dynamic>> orders = [
      {"title": "Food Delivery", "status": "Ongoing"},
      {"title": "Laundry Service", "status": "Ongoing"},
      {"title": "Grocery Purchase", "status": "Completed"},
      {"title": "Car Rental", "status": "Completed"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: const Color(0xFF87027B),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Ongoing Orders",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...orders
              .where((order) => order["status"] == "Ongoing")
              .map((order) => ListTile(
                    leading: const Icon(Icons.pending_actions),
                    title: Text(order["title"]),
                    subtitle: const Text("Waiting for worker to accept"),
                  ))
              .toList(),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Completed Orders",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...orders
              .where((order) => order["status"] == "Completed")
              .map((order) => ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(order["title"]),
                    subtitle: const Text("Successfully completed"),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
