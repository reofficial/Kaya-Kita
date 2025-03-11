import 'package:flutter/material.dart';
import 'dart:convert';
import 'personalinfo.dart';
import 'login.dart';
import 'api_service.dart';
import 'package:provider/provider.dart';
import 'providers/profile_provider.dart';

class RegisterWorkerScreen extends StatefulWidget {
  const RegisterWorkerScreen({super.key});

  @override
  State<RegisterWorkerScreen> createState() => _RegisterWorkerScreenState();
}

class _RegisterWorkerScreenState extends State<RegisterWorkerScreen> {
  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // UI state and error messages
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String? passwordError;
  String? emailError;

  bool hasMinLength = false;
  bool hasUpperCase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;

  bool isLoading = false; // Used for displaying the loading overlay

  // ✅ Email validation
  bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  // ✅ Validate password and update criteria flags
  void validatePassword(String value) {
    setState(() {
      hasMinLength = value.length >= 6;
      hasUpperCase = RegExp(r'[A-Z]').hasMatch(value);
      hasNumber = RegExp(r'[0-9]').hasMatch(value);
      hasSpecialChar = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value);

      // Generate a detailed error message
      List<String> errors = [];

      if (!hasMinLength) errors.add("❌ At least 6 characters");
      if (!hasUpperCase) errors.add("❌ At least one uppercase letter");
      if (!hasNumber) errors.add("❌ At least one number");
      if (!hasSpecialChar) errors.add("❌ At least one special character");

      passwordError = errors.isEmpty ? null : errors.join("\n");
    });
  }

  // ✅ Worker registration function
  Future<void> onRegisterWorker() async {
    setState(() {
      emailError =
          isValidEmail(emailController.text) ? null : "Invalid email format";

      if (passwordController.text.isEmpty) {
        passwordError = "Password cannot be empty";
      } else if (passwordController.text != confirmPasswordController.text) {
        passwordError = "Passwords do not match";
      } else if (!hasMinLength || !hasUpperCase || !hasNumber || !hasSpecialChar) {
        passwordError = "Password does not meet all requirements";
      } else {
        passwordError = null;
      }
    });

    // 🔴 **Stop execution if validation fails**
    if (emailError != null || passwordError != null) {
      return;
    }

    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      // ✅ Fix: Ensure the backend gets the expected field name "email"
      final response = await ApiService.registerWorker(
        emailController.text,  // Ensure email is passed correctly
        passwordController.text,
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String username = responseData['username'] ?? "Worker"; // Fallback

        // Store user data in Provider
        Provider.of<UserProvider>(context, listen: false)
            .setEmail(emailController.text);
        Provider.of<UserProvider>(context, listen: false)
            .setUsername(username);

        // ✅ Navigate to PersonalInfoScreen with correct email field
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PersonalInfoScreen(
              email: emailController.text, // ✅ Ensure email is passed correctly
              password: passwordController.text,
              username: username,
            ),
          ),
        );
      } else if (response.statusCode == 409) {
        setState(() {
          emailError = "Email already exists. Please use a different one.";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed: ${response.body}")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $error")),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Worker',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                      'Create Worker Account',
                      style: TextStyle(
                          color: Color(0xFF000E53),
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      errorText: emailError,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    onChanged: validatePassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      errorText: passwordError,
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      suffixIcon: IconButton(
                        icon: Icon(obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF000E53)),
                      onPressed: onRegisterWorker,
                      child: const Text("Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
