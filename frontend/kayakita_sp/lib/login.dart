import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert';

import 'entrance.dart';
import 'register.dart';
import 'onboarding.dart';

import 'api_service.dart';

import 'package:provider/provider.dart';
import '/providers/profile_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;
  bool isLoading = false; // For the loading overlay

  // Controllers for capturing email and password input.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// This function performs the login API call.
  /// It sends the email and password to the backend, shows a loading indicator,
  /// and navigates to the EntranceScreen upon success.
  Future<void> handleLogin() async {
    setState(() {
      isLoading = true; // Show loading overlay.
    });

    try {
      // Fetch all workers
      final response = await ApiService.getWorkers();

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch workers.");
      }

      final List<dynamic> workers = json.decode(response.body);

      // Extract input email and password
      String inputEmail = emailController.text.trim();
      String inputPassword = passwordController.text;

      // Find worker by email
      final worker = workers.firstWhere(
        (worker) => worker['email'] == inputEmail,
        orElse: () => null,
      );

      if (worker == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email does not exist.")),
        );
        return;
      }

      // Check if password matches
      if (worker['password'] != inputPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incorrect password.")),
        );
        return;
      }

      // Successful login
      String apiEmail = worker['email'];

      Provider.of<UserProvider>(context, listen: false).setEmail(inputEmail);
      Provider.of<UserProvider>(context, listen: false)
          .setUsername(worker['username']);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => EntranceScreen(email: apiEmail)),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $error")),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading overlay.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log("Entered LoginScreen");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Log-in',
          style:
              TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF000000)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingScreen()),
            );
          },
        ),
      ),
      // Wrap the body in a Stack to overlay the loading indicator.
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Login here',
                      style: TextStyle(
                        color: Color(0xFF87027B),
                        fontSize: 30,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: SizedBox(
                      width: 250,
                      child: Text(
                        'Welcome back, you\'ve been missed!',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Email field with controller.
                  CustomTextField(
                    controller: emailController,
                    hintText: "Email",
                  ),
                  const SizedBox(height: 10),
                  // Password field with controller and visibility toggle.
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor:
                          Color(0xFFE8F0FE).withAlpha((0.2 * 255).toInt()),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE8F0FE)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE8F0FE)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF87027B)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const HomeScreen()),
                        // );
                      },
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF87027B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF87027B),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed:
                          handleLogin, // Use the API call on button press.
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterWorkerScreen()),
                        );
                      },
                      child: const Text(
                        'Create a new account',
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
                  const SizedBox(height: 60),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "Or continue with",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                // TODO: Implement Google sign-in.
                              },
                              icon: Image.asset('assets/google.png',
                                  width: 30, height: 30),
                              iconSize: 30,
                            ),
                            const SizedBox(width: 3),
                            IconButton(
                              onPressed: () {
                                // TODO: Implement Facebook sign-in.
                              },
                              icon: Image.asset('assets/facebook.png',
                                  width: 30, height: 30),
                              iconSize: 30,
                            ),
                            const SizedBox(width: 2),
                            IconButton(
                              onPressed: () {
                                // TODO: Implement Apple sign-in.
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
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          // Loading overlay: shows when isLoading is true.
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

// Reusable custom text field widget that accepts a [controller].
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.borderColor = const Color(0xFFE8F0FE),
    this.controller,
  });

  final String hintText;
  final Color borderColor;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
