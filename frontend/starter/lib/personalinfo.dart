import 'package:flutter/material.dart';
import 'dart:developer';
import 'entrance.dart';

class PersonalInfoScreen extends StatelessWidget {
  // Receive the email and password from the registration screen.
  final String email;
  final String password;

  const PersonalInfoScreen({super.key, required this.email, required this.password});

  @override
  Widget build(BuildContext context) {
    // Log the received email and password (for debugging purposes)
    log("Entered PersonalInfoScreen with email: $email and password: $password"); 

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Personal Information',
          style: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF000000)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: -40,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/personalinfo.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        '  User Details',
                        style: TextStyle(
                          color: Color(0xFF87027B),
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 10),
                      // The following fields collect additional user details.
                      // You can also display the passed email/password if needed.
                      CustomTextField(hintText: "First Name"),
                      const SizedBox(height: 10),
                      CustomTextField(hintText: "Middle Initial"),
                      const SizedBox(height: 10),
                      CustomTextField(hintText: "Last Name"),
                      const SizedBox(height: 10),
                      CustomTextField(hintText: "Mobile Number"),
                      const SizedBox(height: 10),
                      CustomTextField(hintText: "Address"),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF87027B),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EntranceScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
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

// Reusable custom text field widget for PersonalInfoScreen.
class CustomTextField extends StatelessWidget {
  final String hintText;
  final Color borderColor;

  const CustomTextField({super.key, required this.hintText, this.borderColor = const Color(0xFFE8F0FE)});

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
          borderSide: const BorderSide(color: Color(0xFF87027B)),
        ),
      ),
    );
  }
}
