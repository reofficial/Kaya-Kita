import 'package:flutter/material.dart';
import 'dart:developer';
import 'personalinfo.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    log("Entered RegisterScreen");
    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF000000)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                      style: TextStyle(
                        color: Color(0xFF87027B),
                        fontSize: 30,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: 250,
                      child: Text(
                        'Create an account so you can explore all the existing services',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextField(hintText: "Email"),
                  SizedBox(height: 10),
                  CustomTextField(hintText: "Password"),
                  SizedBox(height: 10),
                  CustomTextField(hintText: "Confirm Password"),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF87027B),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonalInfoScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16),
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
                            builder: (context) => PersonalInfoScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Already have an account?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),

                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Or continue with",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                // google
                              },
                              icon: Image.asset('assets/google.png', width: 30, height: 30),
                              iconSize: 30, 
                            ),
                            SizedBox(width: 3),
                            IconButton(
                              onPressed: () {
                                // fb
                              },
                              icon: Image.asset('assets/facebook.png', width: 30, height: 30),
                              iconSize: 30,
                            ),
                            SizedBox(width: 2),
                            IconButton(
                              onPressed: () {
                                // apple
                              },
                              icon: Image.asset('assets/apple.png', width: 32, height: 32),
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

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.hintText, this.borderColor = const Color(0xFFE8F0FE)});

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
