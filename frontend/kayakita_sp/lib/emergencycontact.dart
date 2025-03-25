//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'widgets/customappbar.dart';
import 'widgets/customtextfield.dart';
import 'govissue.dart';

class EmergencyContactScreen extends StatefulWidget {
  final Map<String, dynamic> workerData;
  final Map<String, dynamic> certificationData;

  const EmergencyContactScreen({
    super.key,
    required this.workerData,
    required this.certificationData
  });

  @override
  _EmergencyContactScreenState createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
  final TextEditingController emergencyNameController = TextEditingController();
  final TextEditingController relationshipController = TextEditingController();
  final TextEditingController emergencyNumberController = TextEditingController();
  String? isAbove56;
  bool isLoading = false;

  @override
  void dispose() {
    emergencyNameController.dispose();
    relationshipController.dispose();
    emergencyNumberController.dispose();
    super.dispose();
  }

  void onNext() {
    if (emergencyNameController.text.isEmpty ||
        relationshipController.text.isEmpty ||
        emergencyNumberController.text.isEmpty ||
        isAbove56 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Please fill in all required fields.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GovIssueScreen(
          workerData: widget.workerData,
          certificationData: widget.certificationData
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(titleText: 'Application'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
                child: Image.asset('assets/emergency_icon.png', height: 150)),
            const SizedBox(height: 20),
            Text(
              'Emergency Contact',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            CustomTextField(
                hintText: "Emergency Contact Name*",
                controller: emergencyNameController),
            const SizedBox(height: 10),
            CustomTextField(
                hintText: "Relationship*", controller: relationshipController),
            const SizedBox(height: 10),
            CustomTextField(
                hintText: "Emergency Contact Number*",
                controller: emergencyNumberController),
            const SizedBox(height: 15),
            Text("Are you 56 years old and above?*",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              value: isAbove56,
              hint: const Text("Select"),
              items: ["Yes", "No"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  isAbove56 = newValue;
                });
              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                  ),
                  child:
                      const Text("Save", style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF87027B),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Next",
                          style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
