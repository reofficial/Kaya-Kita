import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'api_service.dart';

class DisputeStatusScreen extends StatefulWidget {
  final int ticketNumber;

  const DisputeStatusScreen({super.key, required this.ticketNumber});

  @override
  State<DisputeStatusScreen> createState() => _DisputeStatusScreenState();
}

class _DisputeStatusScreenState extends State<DisputeStatusScreen> {
  late Future<Map<String, dynamic>> matchingDispute;

  @override
  void initState() {
    super.initState();
    matchingDispute = _loadMatchingDispute();
  }

  Future<Map<String, dynamic>> _loadMatchingDispute() async {
    final response = await ApiService.getDisputes();

    print("API Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> allDisputes = json.decode(response.body);

      final match = allDisputes.firstWhere(
        (item) => item['ticket_number'] == widget.ticketNumber,
        orElse: () => throw Exception(
            "No dispute found for ticket #${widget.ticketNumber}"),
      );

      print("Matching Dispute Found: $match");

      final ticketNumber = match['ticket_number'];
      final disputeStatus = match['dispute_status'];
      final reason = match['reason'];
      final workerUsername = match['worker_username'];
      final createdAtRaw = match['created_at'];
      final description = match['description'];

      print("Ticket Number: $ticketNumber");
      print("Dispute Status: $disputeStatus");
      print("Reason: $reason");
      print("Worker Username: $workerUsername");
      print("Created At (Raw): $createdAtRaw");
      print("descrip: $description");

      String formattedDate = 'N/A';
      if (createdAtRaw != null) {
        try {
          final DateTime createdAt = DateTime.parse(createdAtRaw);
          formattedDate = DateFormat('MMM. d, y - h:mm a').format(createdAt);
        } catch (e) {
          print("Error parsing date: $e");
        }
      }

      return {
        'ticket_number': ticketNumber.toString(),
        'dispute_status': disputeStatus?.toString() ?? 'N/A',
        'worker_username': workerUsername?.toString() ?? 'N/A',
        'reason': reason?.toString() ?? 'N/A',
        'created_at': formattedDate,
        'description': description ?? 'N/A',
      };
    } else {
      throw Exception(
          "Failed to load disputes. Status code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dispute Status"),
        backgroundColor: const Color(0xFF87027B),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: matchingDispute,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ticket #${data['ticket_number']}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF87027B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _detailRow("Status", data['dispute_status'] ?? 'N/A'),
                    _detailRow("Reason", data['reason'] ?? 'N/A'),
                    _detailRow("Handyman", data['worker_username' ?? 'N/A']),
                    _detailRow("Description", data['description'] ?? 'N/A'),
                    _detailRow("Raised On", data['created_at'] ?? 'N/A'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
