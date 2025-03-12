import 'package:flutter/material.dart';
import 'emergencycontact.dart';
import 'widgets/customappbar.dart';
import 'widgets/customtextfield.dart';

class ApplicationScreen extends StatefulWidget {
  final String email;
  final String password;
  final String firstName;
  final String middleInitial;
  final String lastName;
  final String contactNumber;
  final String address;
  final String service;

  const ApplicationScreen({
    super.key,
    required this.email,
    required this.password,
    required this.firstName,
    required this.middleInitial,
    required this.lastName,
    required this.contactNumber,
    required this.address,
    required this.service, // TODO: backend handling
  });

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  final TextEditingController _nationalityController = TextEditingController();
  String? _selectedPWDStatus;
  bool _isUploadingSelfie = false;
  bool _isUploadingStatus1 = false;
  bool _isUploadingStatus2 = false;

  @override
  void dispose() {
    _nationalityController.dispose();
    super.dispose();
  }

  // Simulated upload function
  Future<void> _uploadImage(String type) async {
    setState(() {
      if (type == "Selfie") _isUploadingSelfie = true;
      if (type == "Upload Status 1") _isUploadingStatus1 = true;
      if (type == "Upload Status 2") _isUploadingStatus2 = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      if (type == "Selfie") _isUploadingSelfie = false;
      if (type == "Upload Status 1") _isUploadingStatus1 = false;
      if (type == "Upload Status 2") _isUploadingStatus2 = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$type uploaded successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(titleText: 'Application'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hey ${widget.firstName}!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text("You're applying for",
                style: Theme.of(context).textTheme.titleMedium),
            Text(
              widget.service,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
            ),
            const SizedBox(height: 15),

            // Profile Photo Upload
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    child: _isUploadingSelfie
                        ? CircularProgressIndicator()
                        : Icon(Icons.camera_alt,
                            size: 40, color: Colors.black54),
                  ),
                  Positioned(
                    bottom: 0,
                    child: ElevatedButton(
                      onPressed: () => _uploadImage("Selfie"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Take Selfie",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Nationality Input
            CustomTextField(
              hintText: "Nationality*",
              controller: _nationalityController,
            ),
            const SizedBox(height: 15),

            // Upload Status 1
            Text("Upload Status 1 *",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => _uploadImage("Upload Status 1"),
              child: _buildUploadBox(_isUploadingStatus1),
            ),
            const SizedBox(height: 15),

            // Upload Status 2
            Text("Upload Status 2",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => _uploadImage("Upload Status 2"),
              child: _buildUploadBox(_isUploadingStatus2),
            ),
            const SizedBox(height: 15),

            // PWD Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              value: _selectedPWDStatus,
              hint: const Text("Are you a PWD?*"),
              items: ["Yes", "No"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedPWDStatus = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            // Save and Next Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {}, // TODO: Implement Save functionality
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                  ),
                  child:
                      const Text("Save", style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_nationalityController.text.isEmpty ||
                        _selectedPWDStatus == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "⚠️ Please complete all required fields.")),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmergencyContactScreen(
                            password: widget.password,
                            email: widget.email,
                            firstName: widget.firstName,
                            middleInitial: widget.middleInitial,
                            lastName: widget.lastName,
                            contactNumber: widget.contactNumber,
                            address: widget.address,
                            service: widget.service,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade700,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                  ),
                  child:
                      const Text("Next", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Widget for Upload Boxes
  Widget _buildUploadBox(bool isUploading) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.black38),
      ),
      child: isUploading
          ? Center(child: CircularProgressIndicator())
          : Icon(Icons.add, size: 40, color: Colors.black54),
    );
  }
}
