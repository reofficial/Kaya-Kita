import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:math';
import 'api_service.dart';

import 'package:starter/disputechat.dart';

class DisputeStatusScreen extends StatefulWidget {
  final int ticketNumber;

  const DisputeStatusScreen({super.key, required this.ticketNumber});

  @override
  State<DisputeStatusScreen> createState() => _DisputeStatusScreenState();
}

class _DisputeStatusScreenState extends State<DisputeStatusScreen> {
  late Future<Map<String, dynamic>> matchingDispute;
  bool isEscalating = false;
  bool isLoadingChatCheck = false;
  List<String> officialsList = [];
  bool chatExists = false;
  Map<String, dynamic>? existingChat;

  @override
  void initState() {
    super.initState();
    matchingDispute = _loadMatchingDispute();
    _loadOfficials();
    _loadAndCheckChats();
  }

  Future<Map<String, dynamic>> _loadMatchingDispute() async {
    final response = await ApiService.getDisputes();

    if (response.statusCode == 200) {
      final List<dynamic> allDisputes = json.decode(response.body);

      final match = allDisputes.firstWhere(
        (item) => item['ticket_number'] == widget.ticketNumber,
        orElse: () => throw Exception(
            "No dispute found for ticket #${widget.ticketNumber}"),
      );

      final disputeId = match['dispute_id'];
      final ticketNumber = match['ticket_number'];
      final disputeStatus = match['dispute_status'];
      final reason = match['reason'];
      final customerUsername = match['customer_username'];
      final workerUsername = match['worker_username'];
      final createdAtRaw = match['created_at'];
      final description = match['description'];

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
        'dispute_id': disputeId,
        'ticket_number': ticketNumber,
        'dispute_status': disputeStatus,
        'worker_username': workerUsername,
        'customer_username': customerUsername,
        'reason': reason,
        'description': description,
        'created_at': formattedDate,
      };
    } else {
      throw Exception(
          "Failed to load disputes. Status code: ${response.statusCode}");
    }
  }

  Future<void> _loadOfficials() async {
    try {
      final response = await ApiService.getOfficials();
      if (response.statusCode == 200) {
        final List<dynamic> officials = json.decode(response.body);
        setState(() {
          officialsList = officials
              .where((official) => official['username'] != null)
              .map((official) => official['username'].toString())
              .toList();
        });
      }
    } catch (e) {
      print('Error loading officials: $e');
    }
  }

  Future<void> _loadAndCheckChats() async {
    if (isLoadingChatCheck) return;

    setState(() {
      isLoadingChatCheck = true;
      chatExists = false;
      existingChat = null;
    });

    try {
      // Load all chats
      final response = await ApiService.getChats();
      if (response.statusCode == 200) {
        final allChats = json.decode(response.body) as List;

        // Get current dispute data
        final data = await matchingDispute;
        final disputeId = data['dispute_id'];

        // Check for matching chat
        final existing = allChats.firstWhere(
          (chat) => chat['dispute_id'] == disputeId,
          orElse: () => null,
        );

        if (existing != null) {
          setState(() {
            chatExists = true;
            existingChat = existing;
          });
        }
      }
    } catch (e) {
      print('Error loading/checking chats: $e');
    } finally {
      setState(() {
        isLoadingChatCheck = false;
      });
    }
  }

  String _getRandomOfficial() {
    if (officialsList.isEmpty) return '';
    final random = Random();
    return officialsList[random.nextInt(officialsList.length)];
  }

  Future<void> _escalateDispute() async {
    if (isEscalating) return;

    setState(() {
      isEscalating = true;
    });

    try {
      final data = await matchingDispute;
      final officialUsername = _getRandomOfficial();

      if (officialUsername.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No officials available for escalation')),
        );
        return;
      }

      final requestBody = {
        "dispute_id": data['dispute_id'],
        "customer_username": data['customer_username'] ?? '',
        "worker_username": data['worker_username'] ?? '',
        "official_username": officialUsername,
        "chat": []
      };

      final response = await ApiService.createChat(requestBody);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DisputeChatScreen(disputeId: existingChat!['dispute_id']),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to escalate dispute: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error escalating dispute: $e')),
      );
    } finally {
      setState(() {
        isEscalating = false;
      });
    }
  }

  void _viewExistingChat() {
    if (existingChat != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DisputeChatScreen(disputeId: existingChat!['dispute_id']),
        ),
      );
    }
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
            child: Column(
              children: [
                Card(
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
                        const SizedBox(height: 8),
                        _detailRow("Dispute ID",
                            data['dispute_id']?.toString() ?? 'N/A'),
                        const SizedBox(height: 12),
                        _detailRow("Status", data['dispute_status'] ?? 'N/A'),
                        _detailRow("Reason", data['reason'] ?? 'N/A'),
                        _detailRow(
                            "Handyman", data['worker_username'] ?? 'N/A'),
                        _detailRow(
                            "Customer", data['customer_username'] ?? 'N/A'),
                        _detailRow("Description", data['description'] ?? 'N/A'),
                        _detailRow("Raised On", data['created_at'] ?? 'N/A'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (isLoadingChatCheck)
                  const CircularProgressIndicator()
                else if (chatExists)
                  ElevatedButton(
                    onPressed: _viewExistingChat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('View Chat'),
                  )
                else
                  ElevatedButton(
                    onPressed: isEscalating ? null : _escalateDispute,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF87027B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: isEscalating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Escalate Dispute'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
