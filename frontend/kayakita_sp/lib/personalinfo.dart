import 'package:flutter/material.dart';
import 'application.dart';
import 'widgets/customappbar.dart';
import 'widgets/customtextfield.dart';

class PersonalInfoScreen extends StatefulWidget {
  final String email;
  final String password;

  const PersonalInfoScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleInitialController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? selectedService;
  bool isLoading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    middleInitialController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void onContinue() {
    if (firstNameController.text.isEmpty ||
        middleInitialController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        mobileNumberController.text.isEmpty ||
        addressController.text.isEmpty ||
        selectedService == null) {
      _showErrorMessage("⚠️ Please fill in all fields.");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplicationScreen(
          email: widget.email,
          password: widget.password,
          firstName: firstNameController.text,
          middleInitial: middleInitialController.text,
          lastName: lastNameController.text,
          contactNumber: mobileNumberController.text,
          address: addressController.text,
          service: selectedService!,
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(titleText: 'Personal Information'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Worker Details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            CustomTextField(hintText: 'First Name', controller: firstNameController),
            const SizedBox(height: 10),
            CustomTextField(hintText: 'Middle Initial', controller: middleInitialController),
            const SizedBox(height: 10),
            CustomTextField(hintText: 'Last Name', controller: lastNameController),
            const SizedBox(height: 10),
            CustomTextField(hintText: 'Mobile Number', controller: mobileNumberController),
            const SizedBox(height: 10),
            CustomTextField(hintText: 'Address', controller: addressController),
            const SizedBox(height: 20),

            Text(
              'Select Service',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF87027B),
                  ),
            ),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.purple.shade50, 
              ),
              value: selectedService,
              hint: const Text("Choose a service"),
              items: ["Rider", "Driver", "PasaBuy", "Barber", "Carpenter"]
                  .map((String service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Text(
                    service,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF87027B), // Purple text
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedService = newValue;
                });
              },
            ),
            const SizedBox(height: 40),

            Center(
              child: ElevatedButton(
                onPressed: isLoading ? null : onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87027B), // Updated button color
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Continue", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
