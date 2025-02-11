import 'package:flutter/material.dart';
import 'dart:developer';
import 'personalinfo.dart';
import 'login.dart';

import '../widgets/customappbar.dart';
import '../widgets/customtextfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Entered RegisterScreen");
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Register'),
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
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: 250,
                      child: Text(
                        'Create an account so you can explore all the existing services',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    hintText: "Email",
                    controller: _emailController,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    hintText: "Password",
                    obscureText: true,
                    controller:
                        _passwordController, // todo: make password logic with confirm
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    hintText: "Confirm Password",
                    obscureText: true,
                    controller:
                        _passwordController, // todo: make confirm password logic
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF87027B),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonalInfoScreen(
                              username: _usernameController.text,
                              password: _passwordController.text,
                              email: _emailController.text,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Continue",
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
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Already have an account?',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
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
