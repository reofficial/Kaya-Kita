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
  final TextEditingController _messageController = TextEditingController();
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    chatData = _loadChatData();
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
        future: chatData,
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
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(context),
                      ),
                    ),
                    IconButton(
                      icon: isSending
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.send),
                      onPressed: isSending ? null : () => _sendMessage(context),
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
