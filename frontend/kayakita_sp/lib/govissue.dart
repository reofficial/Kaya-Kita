import 'package:flutter/material.dart';
import 'widgets/customappbar.dart';
import 'widgets/customtextfield.dart';
import 'declaration.dart';

class GovIssueScreen extends StatefulWidget {
  final String email;
  final String password;
  final String firstName;
  final String middleInitial;
  final String lastName;
  final String contactNumber;
  final String address;

  const GovIssueScreen({
    super.key,
    required this.email,
    required this.password,
    required this.firstName,
    required this.middleInitial,
    required this.lastName,
    required this.contactNumber,
    required this.address,
  });

  @override
  _GovIssueScreenState createState() => _GovIssueScreenState();
}

class _GovIssueScreenState extends State<GovIssueScreen> {
  String? selectedGovID;
  String? hasClearance;
  final TextEditingController residentialAddressController = TextEditingController();
  bool _isUploadingID = false;
  bool _isUploadingBarangay = false;
  bool _isUploadingLicense = false;
  bool _isUploadingClearance = false;

  @override
  void dispose() {
    residentialAddressController.dispose();
    super.dispose();
  }

  Future<void> _uploadImage(String type) async {
    setState(() {
      if (type == "Government ID") _isUploadingID = true;
      if (type == "Barangay Certificate") _isUploadingBarangay = true;
      if (type == "Licensing Certificate") _isUploadingLicense = true;
      if (type == "Clearance") _isUploadingClearance = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      if (type == "Government ID") _isUploadingID = false;
      if (type == "Barangay Certificate") _isUploadingBarangay = false;
      if (type == "Licensing Certificate") _isUploadingLicense = false;
      if (type == "Clearance") _isUploadingClearance = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$type uploaded successfully!")),
    );
  }

  void onNext() {
    if (selectedGovID == null || residentialAddressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please fill in all required fields.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeclarationScreen(
          email: widget.email,
          password: widget.password,
          firstName: widget.firstName,
          middleInitial: widget.middleInitial,
          lastName: widget.lastName,
          contactNumber: widget.contactNumber,
          address: widget.address,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(titleText: 'Application'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Text(
                'Government Issued ID',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
                value: selectedGovID,
                hint: const Text("Select Government Issued ID"),
                items: ["Passport", "Driver’s License", "SSS ID", "Voter’s ID"].map((String id) {
                  return DropdownMenuItem<String>(
                    value: id,
                    child: Text(id),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedGovID = newValue;
                  });
                },
              ),
              const SizedBox(height: 15),

              Text("Government ID Image (Front)*", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => _uploadImage("Government ID"),
                child: _buildUploadBox(_isUploadingID),
              ),
              const SizedBox(height: 15),

              CustomTextField(hintText: "Residential Address*", controller: residentialAddressController),
              const SizedBox(height: 15),

              Text("Upload Barangay Certificate*", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => _uploadImage("Barangay Certificate"),
                child: _buildUploadBox(_isUploadingBarangay),
              ),
              const SizedBox(height: 15),

              Text("Upload Licensing Certificate*", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => _uploadImage("Licensing Certificate"),
                child: _buildUploadBox(_isUploadingLicense),
              ),
              const SizedBox(height: 20),

              // ✅ New Section: NBI / Police Clearance / CIBI
              Text(
                "NBI / Police Clearance / CIBI",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Text("Do you have NBI / Police Clearance / CIBI?", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
                value: hasClearance,
                hint: const Text("Select"),
                items: ["Yes", "No"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    hasClearance = newValue;
                  });
                },
              ),
              const SizedBox(height: 15),

              if (hasClearance == "Yes") ...[
                Text("Upload Clearance*", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _uploadImage("Clearance"),
                  child: _buildUploadBox(_isUploadingClearance),
                ),
                const SizedBox(height: 20),
              ],

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
                    onPressed: onNext,
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
      ),
    );
  }

  Widget _buildUploadBox(bool isUploading) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.black38),
      ),
      child: isUploading ? const Center(child: CircularProgressIndicator()) : const Icon(Icons.add, size: 40, color: Colors.black54),
    );
  }
}
