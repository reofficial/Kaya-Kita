import 'dart:io';
import 'package:flutter/material.dart';
import 'widgets/customappbar.dart';
import 'widgets/customtextfield.dart';
import 'declaration2.dart';

class GovIssueCertificationScreen extends StatefulWidget {
  final Map<String, dynamic> workerData;
  final Map<String, dynamic> certificationData;

  const GovIssueCertificationScreen({
    super.key,
    required this.workerData,
    required this.certificationData,
  });

  @override
  _GovIssueCertificationScreenState createState() => _GovIssueCertificationScreenState();
}

class _GovIssueCertificationScreenState extends State<GovIssueCertificationScreen> {
  String? selectedGovID;
  String? hasClearance;
  final TextEditingController residentialAddressController = TextEditingController();
  bool _isUploadingID = false;
  bool _isUploadingBarangay = false;
  bool _isUploadingLicense = false;
  bool _isUploadingClearance = false;
  bool _isIDUploaded = false;
  bool _isBarangayUploaded = false;
  bool _isLicenseUploaded = false;
  bool _isClearanceUploaded = false;

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
      if (type == "Government ID") {
        _isUploadingID = false;
        _isIDUploaded = true;
      }
      if (type == "Barangay Certificate") {
        _isUploadingBarangay = false;
        _isBarangayUploaded = true;
      }
      if (type == "Licensing Certificate") {
        _isUploadingLicense = false;
        _isLicenseUploaded = true;
      }
      if (type == "Clearance") {
        _isUploadingClearance = false;
        _isClearanceUploaded = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$type uploaded successfully!")),
    );
  }

  String get isCertified {
    if (selectedGovID == null || !_isIDUploaded || residentialAddressController.text.isEmpty || !_isBarangayUploaded || !_isLicenseUploaded) {
      return "denied";
    }
    if (hasClearance == "Yes" && !_isClearanceUploaded) {
      return "denied";
    }
    return "pending";
  }

  void onNext() {
    if (isCertified == "denied") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please complete all required fields before proceeding.")),
      );
      return;
    }

    widget.workerData['is_certified'] = isCertified;
    print(widget.workerData['is_certified']);
    widget.certificationData['licensing_certificate_given'] = "Professional Driver's License";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeclarationCertificationScreen(
          workerData: widget.workerData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(titleText: 'Certification Application'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('Government Issued ID', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
              Text("Government ID Image (Front)*", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              GestureDetector(onTap: () => _uploadImage("Government ID"), child: _buildUploadBox(_isUploadingID, _isIDUploaded)),
              const SizedBox(height: 15),
              CustomTextField(hintText: "Residential Address*", controller: residentialAddressController),
              const SizedBox(height: 15),
              Text("Upload Barangay Certificate*", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              GestureDetector(onTap: () => _uploadImage("Barangay Certificate"), child: _buildUploadBox(_isUploadingBarangay, _isBarangayUploaded)),
              const SizedBox(height: 15),
              Text("Upload Licensing Certificate*", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              GestureDetector(onTap: () => _uploadImage("Licensing Certificate"), child: _buildUploadBox(_isUploadingLicense, _isLicenseUploaded)),
              const SizedBox(height: 20),
              Text("NBI / Police Clearance / CIBI", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
                value: hasClearance,
                hint: const Text("Select"),
                items: ["Yes", "No"].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) => setState(() => hasClearance = newValue),
              ),
              const SizedBox(height: 15),
              if (hasClearance == "Yes") ...[
                Text("Upload Clearance*", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                GestureDetector(onTap: () => _uploadImage("Clearance"), child: _buildUploadBox(_isUploadingClearance, _isClearanceUploaded)),
                const SizedBox(height: 20),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade400, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14)),
                    child: const Text("Save", style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF87027B), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14)),
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

  Widget _buildUploadBox(bool isUploading, bool isUploaded) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade200, border: Border.all(color: Colors.black38)),
      child: isUploading
          ? const Center(child: CircularProgressIndicator())
          : (isUploaded ? const Icon(Icons.check_circle, color: Colors.green, size: 40) : const Icon(Icons.add, size: 40, color: Colors.black54)),
    );
  }
}
