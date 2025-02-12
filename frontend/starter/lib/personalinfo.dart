import 'package:flutter/material.dart';
import 'dart:developer';
import 'entrance.dart';
import 'api_service.dart'; // Ensure your ApiService has a createCustomer method.

class PersonalInfoScreen extends StatefulWidget {
  // Email and password are received from the registration screen.
  final String email;
  final String password;

  const PersonalInfoScreen({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  // Create controllers for each additional user detail field.
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleInitialController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isLoading = false; // Used for displaying the loading overlay

  @override
  void dispose() {
    // Dispose the controllers when the widget is removed from the widget tree.
    firstNameController.dispose();
    middleInitialController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  /// This function packs all the collected information into a Map that
  /// corresponds to your Customer model and performs the POST API call.
  Future<void> handleSubmit() async {
    Map<String, dynamic> customerData = {
      "email": widget.email,
      "password": widget.password,
      "first_name": firstNameController.text,
      "middle_initial": middleInitialController.text,
      "last_name": lastNameController.text,
      "username": "--", // Default value as specified.
      "address": addressController.text,
      "contact_number": mobileNumberController.text,
    };

    // Log the packed customer data.
    log("Customer Data: $customerData");

    // Show loading overlay while the API call is in progress.
    setState(() {
      isLoading = true;
    });

    try {
      // POST API call using the customerData.
      final response = await ApiService.createCustomer(customerData);
      
      if (response.statusCode == 201) {
        // On success, navigate to the EntranceScreen.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EntranceScreen(),
          ),
        );
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
      // Hide the loading overlay once the API call completes.
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log("Entered PersonalInfoScreen with email: ${widget.email} and password: ${widget.password}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Personal Information',
          style: TextStyle(
            color: Color(0xFF000000),
            fontWeight: FontWeight.bold,
          ),
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
          // Background image.
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
          // Content.
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
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
                        // Collect user details using custom text fields.
                        CustomTextField(
                          controller: firstNameController,
                          hintText: "First Name",
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: middleInitialController,
                          hintText: "Middle Initial",
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: lastNameController,
                          hintText: "Last Name",
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: mobileNumberController,
                          hintText: "Mobile Number",
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: addressController,
                          hintText: "Address",
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF87027B),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: handleSubmit,
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
              ),
            ],
          ),
          // Loading overlay: shows a semi-transparent background and a spinner when isLoading is true.
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

/// A reusable custom text field widget that accepts a [controller] to capture user input.
class CustomTextField extends StatelessWidget {
  final String hintText;
  final Color borderColor;
  final TextEditingController? controller;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.borderColor = const Color(0xFFE8F0FE),
    this.controller,
  }) : super(key: key);

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
