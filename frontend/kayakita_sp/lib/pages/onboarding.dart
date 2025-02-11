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
          // bg
          Container(color: Theme.of(context).primaryColor),
          // purple shape
          Positioned.fill(
            child: CustomPaint(
              painter: PurpleShapePainter(),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.06,
            left: MediaQuery.of(context).size.width * -0.24,
            child: Image.asset(
              'assets/logo.png',
              width: 600,
              height: 500,
            ),
          ),

          // text and button
          Positioned(
            top: MediaQuery.of(context).size.height * 0.65, // 65% down
            left: MediaQuery.of(context).size.width * 0.1, // 20% from left
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'kayakita sp',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Righteous',
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [Colors.purpleAccent, Color(0xFFF71188)],
                      ).createShader(Rect.fromLTWH(0, 0, 200, 50)),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Kahit saan, kahit kailan — kaya kitang tulungan!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),

          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
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
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
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
                        decorationColor: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Roboto',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PurpleShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white;

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.6);
    path.lineTo(size.width * 0.4, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.6, 0,
        size.height * 0.4 // where curve starts in y axis for purple
        );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
