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
    required this.service,
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

  Future<void> _uploadImage(String type) async {
    setState(() {
      if (type == "Selfie") _isUploadingSelfie = true;
      if (type == "Upload Status 1") _isUploadingStatus1 = true;
      if (type == "Upload Status 2") _isUploadingStatus2 = true;
    });

    await Future.delayed(const Duration(seconds: 2));

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
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(titleText: 'Application'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Hey ${widget.firstName}!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    "You're applying for",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    widget.service,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () => _uploadImage("Selfie"),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      child: _isUploadingSelfie
                          ? const CircularProgressIndicator()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.camera_alt,
                                    size: 30, color: Colors.black54),
                                const SizedBox(height: 5),
                                Text("Take Selfie",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildRow("Nationality*", _buildTextField(_nationalityController)),
            const SizedBox(height: 20),

            _buildRow("Upload Status 1*", _buildUploadBox(_isUploadingStatus1, "Upload Status 1")),
            const SizedBox(height: 20),

            _buildRow("Upload Status 2", _buildUploadBox(_isUploadingStatus2, "Upload Status 2")),
            const SizedBox(height: 20),

            _buildRow("Are you a PWD?*", _buildDropdown()),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  child: const Text("Save", style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_nationalityController.text.isEmpty || _selectedPWDStatus == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("⚠️ Please complete all required fields.")),
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
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  child: const Text("Next", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, Widget child) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 10),
        Expanded(flex: 3, child: child),
      ],
    );
  }

  Widget _buildUploadBox(bool isUploading, String type) {
    return GestureDetector(
      onTap: () => _uploadImage(type),
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.black38),
        ),
        child: isUploading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, size: 30, color: Colors.black54),
                  const SizedBox(height: 5),
                  Text("Upload 1x1 photo",
                      style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return CustomTextField(controller: controller);
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      value: _selectedPWDStatus,
      hint: const Text("Select"),
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
    );
  }
}
