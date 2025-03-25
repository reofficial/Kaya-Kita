import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inbox"),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: chatData.length,
        itemBuilder: (context, index) {
          final Map<String, String?> chat = chatData[index]; 
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chat['avatar'] ?? 'https://via.placeholder.com/150'),
            ),
            title: Text(chat['name'] ?? 'Unknown', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(chat['lastMessage'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(chat['time'] ?? ''),
            onTap: () {
              // TODO: yung chat screen
            },
          );
        },
      ),
    );
  }
}

List<Map<String, String?>> chatData = [
  {
    "name": "Alice Johnson",
    "avatar": "apple.png",
    "lastMessage": "Hey! How have you been?",
    "time": "2m ago"
  },
  {
    "name": "Bob Smith",
    "avatar": null, 
    "lastMessage": "Let's catch up later!",
    "time": "5m ago"
  },
  {
    "name": "Charlie Brown",
    "avatar": "facebook.png",
    "lastMessage": "Got it! Thanks!",
    "time": "10m ago"
  },
];
