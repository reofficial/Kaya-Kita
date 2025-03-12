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
  bool _isChecked = false;

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
  }

  void onNext() {
    if (!_isChecked || selectedGovID == null || residentialAddressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please complete all required fields before proceeding.")),
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

              Text('Government Issued ID',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
                  return DropdownMenuItem<String>(value: id, child: Text(id));
                }).toList(),
                onChanged: (newValue) => setState(() => selectedGovID = newValue),
              ),
              const SizedBox(height: 15),

              _buildRow("Government ID Image (Front)*", "Government ID", _isUploadingID),
              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple, width: 1.5),
                ),
                child: TextField(
                  controller: residentialAddressController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Residential Address*",
                  ),
                ),
              ),
              const SizedBox(height: 15),

              _buildRow("Upload Barangay Certificate*", "Barangay Certificate", _isUploadingBarangay),
              const SizedBox(height: 15),

              _buildRow("Upload Licensing Certificate*", "Licensing Certificate", _isUploadingLicense),
              const SizedBox(height: 15),

              Text("NBI / Police Clearance / CIBI",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  value: hasClearance,
                  hint: const Text("Do you have NBI / Police Clearance / CIBI?"),
                  items: ["Yes", "No"].map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) => setState(() => hasClearance = newValue),
                ),
              ),
              const SizedBox(height: 15),

              if (hasClearance == "Yes")
                _buildRow("Upload Clearance*", "Clearance", _isUploadingClearance),
              const SizedBox(height: 15),

              Row(
                children: [
                  Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) => setState(() => _isChecked = value ?? false)),
                  Expanded(
                    child: Text(
                      "All information provided above is accurate, and the Service Provider acknowledges that their account may be deactivated if any information provided, such as the 'Address of Residency,' is found to be incorrect.",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14)),
                    child: const Text("Save", style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14)),
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

  Widget _buildRow(String label, String uploadType, bool isUploading) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 2, child: Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: GestureDetector(onTap: () => _uploadImage(uploadType), child: _buildUploadBox(isUploading)),
        ),
      ],
    );
  }

  Widget _buildUploadBox(bool isUploading) {
    return Container(
      height: 100,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade200, border: Border.all(color: Colors.black38)),
      child: isUploading ? const Center(child: CircularProgressIndicator()) : const Icon(Icons.add, size: 40, color: Colors.black54),
    );
  }
}
