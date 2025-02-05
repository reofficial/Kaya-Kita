//ignore this one -- this is a test onboarding UI

import 'package:flutter/material.dart';
import 'main.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(color: Colors.white),
          // Custom Painted Shape
          Positioned.fill(
            child: CustomPaint(
              painter: PurpleShapePainter(),
            ),
          ),
          // Welcome Text & Button
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome to the App!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Home Page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Flutter Demo Home Page')),
                    );
                  },
                  child: Text('Get Started'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PurpleShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFF87027B); // Purple color

    Path path = Path();

    // Move to the top-left corner
    path.moveTo(0, 0);

    // Draw the top edge (straight line)
    path.lineTo(size.width, 0);

    // Draw the right edge (straight line)
    path.lineTo(size.width, size.height * 0.6);  // Upper half of the screen height

    // Add the bottom-right edge (straight line)
     path.lineTo(0, size.height * 0.5);

    // Now, draw the bottom-left corner rounded with a quadratic Bezier curve
    path.arcToPoint(
      Offset(100, size.height),
      radius: Radius.circular(30), // Adjust this value for how rounded the corner is
      clockwise: false,
    );

    path.close(); // Close the path to complete the shape

    // Draw the path on the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
