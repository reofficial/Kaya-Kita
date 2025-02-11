import 'package:flutter/material.dart';
import 'dart:developer';
import 'entrance.dart';
import 'home.dart';
import 'register.dart';

import '../widgets/customappbar.dart';
import '../widgets/customtextfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    log("Entered LoginScreen");
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Log-in'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Login here',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: 250,
                      child: Text(
                        'Welcome back, you\'ve been missed!',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextField(hintText: "Email"),
                  SizedBox(height: 10),
                  CustomTextField(
                    hintText: "Password",
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot your password?',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EntranceScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign in",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Create a new account',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Or continue with",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                // google
                              },
                              icon: Image.asset('assets/google.png',
                                  width: 30, height: 30),
                              iconSize: 30,
                            ),
                            SizedBox(width: 3),
                            IconButton(
                              onPressed: () {
                                // fb
                              },
                              icon: Image.asset('assets/facebook.png',
                                  width: 30, height: 30),
                              iconSize: 30,
                            ),
                            SizedBox(width: 2),
                            IconButton(
                              onPressed: () {
                                // apple
                              },
                              icon: Image.asset('assets/apple.png',
                                  width: 32, height: 32),
                              iconSize: 32,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hintText,
      this.borderColor = const Color(0xFFE8F0FE)});

  final String hintText;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: borderColor.withAlpha((0.2 * 255).toInt()),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF87027B)),
        ),
      ),
    );
  }
}
*/
