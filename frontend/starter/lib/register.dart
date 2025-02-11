import 'package:flutter/material.dart';
import 'api_service.dart';
import 'personalinfo.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String? passwordError;
  String? emailError;
  
  bool hasMinLength = false;
  bool hasUpperCase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;

  void validatePassword(String value) {
    setState(() {
      hasMinLength = value.length >= 6;
      hasUpperCase = RegExp(r'[A-Z]').hasMatch(value);
      hasNumber = RegExp(r'[0-9]').hasMatch(value);
      hasSpecialChar = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value);
    });
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }


  void onRegister() {
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

  if (emailError == null && passwordError == null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PersonalInfoScreen()),
    );
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
      body: SingleChildScrollView(
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
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  errorText: emailError,
                  errorStyle: const TextStyle(
                  fontSize: 14, 
                  color: Colors.red, 
                ),
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
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF87027B)),
                  onPressed: onRegister,
                  child: const Text("Continue", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 10),
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
                            // google
                          },
                          icon: Image.asset('assets/google.png', width: 30, height: 30),
                          iconSize: 30,
                        ),
                        const SizedBox(width: 3),
                        IconButton(
                          onPressed: () {
                            // fb
                          },
                          icon: Image.asset('assets/facebook.png', width: 30, height: 30),
                          iconSize: 30,
                        ),
                        const SizedBox(width: 2),
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}


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
        fillColor: const Color(0xFFE8F0FE).withAlpha((0.2 * 255).toInt()),
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
      ),
    );
  }
}
