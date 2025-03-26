import 'package:flutter/material.dart';
import 'package:kayakita_sp/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'emergencycontact2.dart';
import 'widgets/customappbar.dart';
import 'widgets/customtextfield.dart';
import 'package:intl/intl.dart';

class ApplicationCertificationScreen extends StatefulWidget {
  final Map<String, dynamic> workerData;

  const ApplicationCertificationScreen({
    super.key,
    required this.workerData,
  });

  @override
  State<ApplicationCertificationScreen> createState() => _ApplicationCertificationState();
}

class _ApplicationCertificationState extends State<ApplicationCertificationScreen> {
  final TextEditingController _nationalityController = TextEditingController();
  String? _selectedPWDStatus;
  bool _isUploadingSelfie = false;
  bool _isUploadingStatus1 = false;
  bool _isUploadingStatus2 = false;

  late Map<String, dynamic> certificationData;
  late String workerUsername;
  late String applicationDate;

  @override
  void initState() {
    super.initState();
    workerUsername = Provider.of<UserProvider>(context, listen: false).username;
    certificationData = {
      'workerUsername': workerUsername,
      'date_of_application': '',
      'licensing_certificate_given': '',
      'is_senior': false,
      'is_pwd': false,
    };
  }

  @override
  void dispose() {
    _nationalityController.dispose();
    super.dispose();
  }

  void onContinue() {
    if (_nationalityController.text.isEmpty || _selectedPWDStatus == null) {
      _showErrorMessage("⚠️ Please fill in all fields.");
      return;
    }

    applicationDate = DateFormat("MMMM d, y - h:mm a").format(DateTime.now().toUtc().add(const Duration(hours: 8)));

    certificationData['date_of_application'] = applicationDate;
    certificationData['is_pwd'] = _selectedPWDStatus == "Yes" ? true : false;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmergencyContactCertificationScreen(
          workerData: widget.workerData,
          certificationData: certificationData,
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$type uploaded successfully!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(titleText: 'Certification Application'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text('Hey ${widget.workerData['firstName']}!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  Text("You're applying for", style: Theme.of(context).textTheme.titleMedium),
                  Text(widget.workerData['service'],
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold, color: Colors.purple)),
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
                                const Icon(Icons.camera_alt, size: 30, color: Colors.black54),
                                const SizedBox(height: 5),
                                Text("Take Selfie", style: Theme.of(context).textTheme.labelSmall),
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
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF87027B),
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
        Expanded(flex: 2, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
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
                  Text("Upload 1x1 photo", style: Theme.of(context).textTheme.labelSmall),
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
