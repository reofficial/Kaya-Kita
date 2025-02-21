import 'package:flutter/material.dart';
import 'dart:ui';

class JobInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipPath(
                    clipper: CurvedAppBar(),
                    child: Container(
                      height: 140, 
                      color: Colors.green,
                      child: AppBar(
                        title: Text('Job Information'),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        toolbarHeight: 80,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 90, 
                    left: MediaQuery.of(context).size.width / 2 - 40,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/kamala.png'),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
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
                          SizedBox(height: 10),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CurvedAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    double startX = 0;
    double startY = size.height;
    double curveStartX = size.width * 0.35;
    double curveEndX = size.width * 0.65;
    double endX = size.width;
    double controlX = size.width * 0.5; 
    double controlY = size.height * 0.3; 

    double roundness = size.width * 0.085; 

    path.lineTo(0, startY);
    path.lineTo(curveStartX - roundness, startY);

    path.quadraticBezierTo(
        curveStartX - roundness / 2, startY, 
        curveStartX, startY - roundness / 2);

    path.quadraticBezierTo( // main curve
        controlX, controlY, 
        curveEndX, startY - roundness / 2);

    path.quadraticBezierTo( //trasnition curve
        curveEndX + roundness / 2, startY, 
        curveEndX + roundness, startY);

    path.lineTo(endX, startY);
    path.lineTo(endX, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
