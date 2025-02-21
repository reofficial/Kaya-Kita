import 'package:flutter/material.dart';

class JobInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Job Information'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                SizedBox(height: 8),
                Text(
                  'Kamala Harris',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.verified, color: Colors.purple, size: 20),
                Divider(),
                Text(
                  'Personal Chef Wanted',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, I am looking for a personal chef to prepare breakfast, lunch, and dinner, as well as school lunches for my kids.',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ideal Rate: 30,000/month',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      Text(
                        'Duration: 1 month',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Location: Makati City',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Submitted on 6 Dec, 2024 - 4:56 PM',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Divider(),
                Text(
                  'Contact Me!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.email, color: Colors.grey),
                  title: Text('kdharris@up.edu.ph'),
                ),
                ListTile(
                  leading: Icon(Icons.location_on, color: Colors.grey),
                  title: Text('UP Diliman, Quezon City'),
                ),
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.grey),
                  title: Text('Booked 48 services so far'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('Delete Post'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                      ),
                      child: Text('Edit Post'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
