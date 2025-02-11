import 'package:flutter/material.dart';
import 'pages/onboarding.dart';
import 'theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: OnboardingScreen(),
    );
  }
}
