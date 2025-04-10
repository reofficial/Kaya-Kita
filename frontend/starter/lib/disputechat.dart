import 'package:flutter/material.dart';
import 'dart:convert';

import 'api_service.dart';
import 'package:provider/provider.dart';
import 'providers/profile_provider.dart'; // Update with your actual path

class DisputeChatScreen extends StatefulWidget {
  final int disputeId;

  const DisputeChatScreen({super.key, required this.disputeId});

  @override
  State<DisputeChatScreen> createState() => _DisputeChatScreenState();
}

class _DisputeChatScreenState extends State<DisputeChatScreen> {
  late Future<Map<String, dynamic>> chatData;
  late Future<Map<String, dynamic>> disputeData;
  final TextEditingController _messageController = TextEditingController();
  bool isSending = false;
  bool isChatEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    chatData = _loadChatData();
    disputeData = _loadDisputeData().then((dispute) {
      setState(() {
        isChatEnabled = dispute['dispute_status'] == 'Under Review';
      });
      return dispute;
    });
  }

  Future<Map<String, dynamic>> _loadDisputeData() async {
    final response = await ApiService.getDisputes();
    if (response.statusCode == 200) {
      final allChats = json.decode(response.body) as List;
      final dispute = allChats.firstWhere(
        (dispute) => dispute['dispute_id'] == widget.disputeId,
        orElse: () => throw Exception('Dispute ${widget.disputeId} not found'),
      );
      return dispute;
    } else {
      throw Exception('Failed to load disputes: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> _loadChatData() async {
    final response = await ApiService.getChats();
    if (response.statusCode == 200) {
      final allChats = json.decode(response.body) as List;
      final chat = allChats.firstWhere(
        (chat) => chat['dispute_id'] == widget.disputeId,
        orElse: () =>
            throw Exception('Chat not found for dispute ${widget.disputeId}'),
      );
      return chat;
    } else {
      throw Exception('Failed to load chats: ${response.statusCode}');
    }
  }

  Future<void> _sendMessage(BuildContext context) async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Refresh dispute data before sending
    try {
      final freshDisputeData = await _loadDisputeData();
      if (freshDisputeData['dispute_status'] != 'Under Review') {
        setState(() {
          isChatEnabled = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Cannot send message: Dispute is no longer under review')),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking dispute status: $e')),
      );
      return;
    }

    final username = Provider.of<UserProvider>(context, listen: false).username;

    setState(() {
      isSending = true;
    });

    try {
      final currentChat = await chatData;

      final response = await ApiService.updateChat(
        currentChat,
        message,
        username,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _messageController.clear();
        setState(() {
          chatData = _loadChatData(); // Refresh chat data
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).username;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat for Dispute #${widget.disputeId}'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future:
            Future.wait([chatData, disputeData]).then((results) => results[0]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final chat = snapshot.data!;
          return Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer: ${chat['customer_username']}'),
                  Text('Worker: ${chat['worker_username']}'),
                  Text('Official: ${chat['official_username']}'),
                  FutureBuilder<Map<String, dynamic>>(
                    future: disputeData,
                    builder: (context, disputeSnapshot) {
                      if (disputeSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox();
                      } else if (disputeSnapshot.hasError) {
                        return Text('Status: Error loading status');
                      }
                      return Text(
                        'Status: ${disputeSnapshot.data!['dispute_status']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isChatEnabled ? Colors.green : Colors.red,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: chat['chat']?.length ?? 0,
                  itemBuilder: (context, index) {
                    final messageEntry = chat['chat'][index];
                    final username = messageEntry.keys.first;
                    final message = messageEntry.values.first;
                    final isCurrentUser = username == currentUser;

                    return Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? Colors.blue[100]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isCurrentUser
                                ? const Radius.circular(12)
                                : const Radius.circular(0),
                            bottomRight: isCurrentUser
                                ? const Radius.circular(0)
                                : const Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isCurrentUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(message),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: isChatEnabled
                              ? 'Type your message...'
                              : 'Chat is disabled (dispute not under review)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabled: isChatEnabled,
                        ),
                        onSubmitted:
                            isChatEnabled ? (_) => _sendMessage(context) : null,
                        readOnly: !isChatEnabled,
                      ),
                    ),
                    IconButton(
                      icon: isSending
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.send),
                      onPressed: isChatEnabled && !isSending
                          ? () => _sendMessage(context)
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
