import 'package:flutter/material.dart';
import 'api_service.dart'; // Import our API service that performs the HTTP POST
import 'personalinfo.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Variables to handle UI state and validation errors
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String? passwordError;
  String? emailError;
  
  bool hasMinLength = false;
  bool hasUpperCase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;
  
  bool isLoading = false; // Flag for showing a loading overlay

  // Validate password and update password criteria booleans
  void validatePassword(String value) {
    setState(() {
      hasMinLength = value.length >= 6;
      hasUpperCase = RegExp(r'[A-Z]').hasMatch(value);
      hasNumber = RegExp(r'[0-9]').hasMatch(value);
      hasSpecialChar = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value);
    });
  }

  // Simple email regex validation
  bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  // Updated registration function that now includes an API call
  Future<void> onRegister() async {
    // Validate email and password fields before calling the API.
    setState(() {
      emailError = isValidEmail(emailController.text) ? null : "Invalid email format";

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

    // Proceed only if there are no validation errors.
    if (emailError == null && passwordError == null) {
      setState(() {
        isLoading = true; // Show loading indicator during API call
      });

      try {
        // API CALL: Register the user by sending email and password.
        // The ApiService.registerUser method sends a POST request to the backend.
        final response = await ApiService.registerUser(
          emailController.text,
          passwordController.text,
        );

        // If the response status is 201, registration was successful.
        if (response.statusCode == 201) {
          // Navigate to the PersonalInfoScreen upon successful registration.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
          );
        } else {
          // If registration fails, display an error message.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registration failed: ${response.body}")),
          );
        }
      } catch (error) {
        // Catch any errors during the API call and show a snackbar.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $error")),
        );
      } finally {
        // Hide the loading indicator once the API call is done.
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Stack allows us to overlay a loading indicator over the form
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
                      'Create Account',
                      style: TextStyle(color: Color(0xFF87027B), fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Email text field with error message handling
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      errorText: emailError,
                      errorStyle: const TextStyle(fontSize: 14, color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Password text field with visibility toggle and validation
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    onChanged: validatePassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      errorText: passwordError,
                      errorStyle: const TextStyle(fontSize: 14, color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Display password requirements
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PasswordRequirement(text: "At least 6 characters", satisfied: hasMinLength),
                      PasswordRequirement(text: "At least one uppercase letter", satisfied: hasUpperCase),
                      PasswordRequirement(text: "At least one number", satisfied: hasNumber),
                      PasswordRequirement(text: "At least one special character", satisfied: hasSpecialChar),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Confirm Password text field with visibility toggle
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: IconButton(
                        icon: Icon(obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Button that triggers the registration (and API call)
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF87027B)),
                      onPressed: onRegister,
                      child: const Text("Continue", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Button to navigate to the login page
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
                      child: const Text(
                        'Already have an account?',
                        style: TextStyle(decoration: TextDecoration.underline, fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Social login section
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "Or continue with",
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                // TODO: Implement Google sign-in
                              },
                              icon: Image.asset('assets/google.png', width: 30, height: 30),
                              iconSize: 30,
                            ),
                            const SizedBox(width: 3),
                            IconButton(
                              onPressed: () {
                                // TODO: Implement Facebook sign-in
                              },
                              icon: Image.asset('assets/facebook.png', width: 30, height: 30),
                              iconSize: 30,
                            ),
                            const SizedBox(width: 2),
                            IconButton(
                              onPressed: () {
                                // TODO: Implement Apple sign-in
                              },
                              icon: Image.asset('assets/apple.png', width: 32, height: 32),
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
          // Loading overlay displayed when isLoading is true
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

// Widget to display password requirements with an icon indicator.
class PasswordRequirement extends StatelessWidget {
  final String text;
  final bool satisfied;

  const PasswordRequirement({super.key, required this.text, required this.satisfied});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(satisfied ? Icons.check_circle : Icons.circle, color: satisfied ? Colors.green : Colors.grey, size: 16),
          const SizedBox(width: 5),
          Text(text, style: TextStyle(color: satisfied ? Colors.green : Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}

// (Optional) CustomTextField widget for reuse if needed.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.borderColor = const Color(0xFFE8F0FE),
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String hintText;
  final Color borderColor;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
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
