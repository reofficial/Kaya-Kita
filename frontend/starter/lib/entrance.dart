import 'package:flutter/material.dart';
import 'home.dart';

class EntranceScreen extends StatefulWidget {
  const EntranceScreen({super.key});

  @override
  EntranceScreenState createState() => EntranceScreenState();
}

class EntranceScreenState extends State<EntranceScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()), 
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF87027B),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/logofull.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                Text(
                  'Logging-in...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
