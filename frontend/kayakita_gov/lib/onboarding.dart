import 'package:flutter/material.dart';
import 'register.dart';
import 'login.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(color: Colors.white),
          // Purple shape
          Positioned.fill(
            child: CustomPaint(
              painter: PurpleShapePainter(),
            ),
          ),
          // Logo
          Positioned(
            top: MediaQuery.of(context).size.height * 0.06,
            left: MediaQuery.of(context).size.width * -0.24,
            child: Image.asset(
              'assets/logo.png',
              width: 600,
              height: 500,
            ),
          ),
          // Text and button
          Positioned(
            top: MediaQuery.of(context).size.height * 0.65,
            left: MediaQuery.of(context).size.width * 0.1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'kayakita gov',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Righteous',
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [Color(0xFF000E53), Color(0xFFF71188)],
                      ).createShader(Rect.fromLTWH(0, 0, 200, 50)),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Kahit saan, kahit kailan — kaya kitang tulungan!',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          // Seal, Divider, and Buttons
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.01,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Seal Image
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/philcoatofarms.png',
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(height: 10),
                  // Register Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF000E53),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Log-in',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  // Login Button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Create account',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ],
              ),
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
    Paint paint = Paint()..color = const Color(0xFF000E53);

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.6);
    path.lineTo(size.width * 0.4, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.1, size.height * 0.6,
      0, size.height * 0.4,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
