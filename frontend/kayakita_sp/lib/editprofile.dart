//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';

import 'api_service.dart';

import 'package:provider/provider.dart';
import '/providers/profile_provider.dart'; // Adjust import as needed

String originalEmail = "";
String certification = "";

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  //final TextEditingController nameController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController middleinitialController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController rateController = TextEditingController();

  @override
  void dispose() {
    //nameController.dispose();
    firstnameController.dispose();
    middleinitialController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    rateController.dispose();
    super.dispose();
  }

  Map<String, dynamic>? workerData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchWorkerDetails();
      fetchWorkerRate();
    });
  }

  Future<void> fetchWorkerDetails() async {
    final String email =
        Provider.of<UserProvider>(context, listen: false).email;

    try {
      final response = await ApiService.getWorkers();

      if (response.statusCode == 200) {
        List<dynamic> workers = json.decode(response.body);
        Map<String, dynamic>? matchedWorker = workers.firstWhere(
          (worker) => worker['email'] == email,
          orElse: () => null,
        );

        if (matchedWorker != null) {
          setState(() {
            workerData = matchedWorker;
            firstnameController.text = matchedWorker['first_name'] ?? '';
            middleinitialController.text =
                matchedWorker['middle_initial'] ?? '';
            lastnameController.text = matchedWorker['last_name'] ?? '';
            emailController.text = matchedWorker['email'] ?? '';
            // Save email as a global variable for retrieval later
            originalEmail = matchedWorker['email'] ?? '';
            mobileController.text = matchedWorker['contact_number'] ?? '';
            addressController.text = matchedWorker['address'] ?? '';
            //certification = matchedWorker['is_certified'];

            /*
            // Format the full name as "First M. Last"
            String firstName = firstnameController.text;
            String middleInitial = middleinitialController.text.isNotEmpty
                ? "${middleinitialController.text}."
                : "";
            String lastName = lastnameController.text;

            nameController.text = "$firstName $middleInitial $lastName".trim();
            */
          });
        }
      }
    } catch (e) {
      log("Error fetching customer data: $e");
    }
  }

  Future<void> fetchWorkerRate() async {
    try {
      debugPrint(originalEmail);
      final response = await ApiService.getRateByEmail(originalEmail);
      debugPrint(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic>? matchedWorker = json.decode(response.body);

        if (matchedWorker != null) {
          setState(() {
            rateController.text = matchedWorker['rate'].toString();
          });
        }
      }
    } catch (e) {
      log("Error fetching customer data: $e");
    }
  }

  Future<void> handleUpdate() async {
    try {
      Map<String, dynamic> updateDetails = {
        'current_email': originalEmail,
        'first_name': firstnameController.text,
        'middle_initial': middleinitialController.text,
        'last_name': lastnameController.text,
        'email': emailController.text,
        'contact_number': mobileController.text,
        'address': addressController.text,
        'is_certified': certification
      };

      final response1 = await ApiService.updateWorker(updateDetails);
      final response2 = await ApiService.updateRate(
          originalEmail, double.tryParse(rateController.text) ?? 0.0);

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        // update provider email
        Provider.of<UserProvider>(context, listen: false)
            .setEmail(emailController.text);
        // show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating customer data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    log("Entered EditProfileScreen");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Worker Profile',
            style: TextStyle(fontSize: 20, color: Color(0xFFE8F0FE)),
          ),
          backgroundColor: Color(0xFF87027B),
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFFE8F0FE)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle,
                  size: 40, color: Color(0xFFE8F0FE)),
              tooltip: 'Profile',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(height: 30),
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: IconButton(
                    icon: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white, // Placeholder icon
                    ),
                    onPressed: () {},
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding:
                        EdgeInsets.all(4), // Padding around the camera icon
                    decoration: BoxDecoration(
                      color: Colors.blue, // Background color
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white, width: 2), // White border
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 15, // Camera icon size
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  CustomText(text: "Name"),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: firstnameController,
                    hintText: "First Name",
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: middleinitialController,
                    hintText: "Middle Initial",
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: lastnameController,
                    hintText: "Last Name",
                  ),
                  SizedBox(height: 12),
                  CustomText(text: "Email"),
                  SizedBox(height: 10),
                  CustomTextField(
                      controller: emailController, hintText: "Email"),
                  SizedBox(height: 12),
                  CustomText(text: "Mobile Number"),
                  SizedBox(height: 10),
                  CustomTextField(
                      controller: mobileController, hintText: "Mobile Number"),
                  SizedBox(height: 12),
                  CustomText(text: "Address"),
                  SizedBox(height: 10),
                  CustomTextField(
                      controller: addressController, hintText: "Address"),
                  SizedBox(height: 12),
                  CustomText(text: "Rate (Php/hr)"),
                  SizedBox(height: 10),
                  CustomTextField(
                      controller: rateController, hintText: "Rate (Php/hr)"),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF87027B),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: handleUpdate,
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xFF000000),
        fontWeight: FontWeight.bold,
        fontSize: 14,
        fontFamily: 'Roboto',
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.borderColor = const Color(0xFFE8F0FE),
    required this.controller, // Controller for prefilled data
    this.value = '',
    this.enabled = true, // add parameter 'enabled: false' to disable editing
  });

  final String hintText;
  final Color borderColor;
  final TextEditingController controller;
  final String value;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        child: TextField(
          controller: controller, // Bind the controller
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              fontFamily: 'Roboto',
              color: Colors.black87.withAlpha(95),
            ),
            filled: true,
            fillColor: borderColor.withAlpha((0.2 * 255).toInt()),
            contentPadding: EdgeInsets.only(top: 1.0, bottom: 1.0, left: 10.0),
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
        ));
  }
}
