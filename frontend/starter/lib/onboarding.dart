import 'package:flutter/material.dart';
import 'main.dart';
import 'personalinfo.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // bg
          Container(color: Colors.white),
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
                  'kayakita',
                  style: TextStyle(fontSize: 30, fontFamily: 'Righteous', fontWeight: FontWeight.bold, 
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [Color(0xFF87027B), Color(0xFFF71188)],
                      ).createShader(Rect.fromLTWH(0, 0, 200, 50)),
                  ),),
                 SizedBox(height: 10), 

                Text(
                  'Kahit saan, kahit kailan — kaya kitang tulungan!',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87, 
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal
                  )
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
                      backgroundColor: Color(0xFF87027B), // button color to purple
                      foregroundColor: Colors.white, // text white
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), 
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
                        ),
                      );
                    },
                    child: Text('Register'),
                  ),
                  SizedBox(height: 2), 
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalInfoScreen(), 
                        ),
                      );
                    },
                    child: Text(
                      'Log-in',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold, 
                        color: Color(0xFF000000), 
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
    Paint paint = Paint()..color = const Color(0xFF87027B); 

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.6);
    path.lineTo(size.width * 0.4, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.1, size.height * 0.6, 
      0, size.height * 0.4 // where curve starts in y axis for purple
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
