import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kayakita_gov/api_service.dart';
import 'package:kayakita_gov/certification.dart';

class CertifyWorkerScreen extends StatefulWidget {
  const CertifyWorkerScreen({
    super.key,
    required this.workerUsername
  });

  final String workerUsername;

  @override
  State<CertifyWorkerScreen> createState() => _CertifyWorkerScreenState();
}

class _CertifyWorkerScreenState extends State<CertifyWorkerScreen> {
  late Future<void> _loadWorker;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorker = findWorkerByUsername().then((_) {
      setState(() => isLoading = false);
    });
  }

  late Map<String,dynamic> worker;

  Future<void> findWorkerByUsername() async {
    final response = await ApiService.getWorkers();

    final List<dynamic> data = json.decode(response.body);

    worker = data.firstWhere((w) => w['username'] == widget.workerUsername);
  }

  Future<void> updateCertification() async {
    try {
      Map<String, dynamic> updateDetails = {
        'current_email': worker['email'],
        'first_name': worker['first_name'],
        'middle_initial': worker['middle_initial'],
        'last_name': worker['last_name'],
        'email': worker['email'],
        'contact_number': worker['contact_number'],
        'address': worker['address'],
        'is_certified': worker['is_certified']
      };

      final response = await ApiService.updateWorker(updateDetails);
      print(response.statusCode);

      if (response.statusCode == 200) {
      
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
            worker['is_certified'] == 'ongoing' ? 
            "Certification accepted successfully."
            : "Certification denied successfully.")),
        );

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating certification: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certify Worker', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF000E53),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: FutureBuilder<void>(
        future: _loadWorker,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading worker data'));
          } else {
            return buildWorkerContent();
          }
        },
      ),
    );
  }

  Widget buildWorkerContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.18,
              child: Image.asset('assets/kamala.png'),
            ),
            const SizedBox(height: 10),
            Text(
              widget.workerUsername,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const Text('Applied on October 8, 2024'),
            const SizedBox(height: 10),
            Text(
              worker['is_certified'] == 'ongoing'
                  ? 'Certified until October 8, 2025'
                  : worker['is_certified'] == 'denied'
                      ? 'Denied Certification'
                      : 'Not Certified',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),

            worker['is_certified'] == 'pending' ?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton('Deny', Colors.red),
                  _buildButton('Accept', Colors.green),
                ],
              )
            :
              worker['is_certified'] == 'ongoing' ?
                _buildButtonLong('Revoke', Colors.red)
                : _buildButtonLong('Reapply', Colors.green),
            const SizedBox(height: 10),
            _customContainer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                spacing: 5, 
                children: [
                  Text(
                    'Personal Information', 
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                  ),
                  _buildInfo('Nationality', 'Filipino'),
                  Divider(height: 1, color: Colors.grey, indent: 40, endIndent: 40),
                  _buildInfo('Address', 'Address'),
                  Divider(height: 1, color: Colors.grey, indent: 40, endIndent: 40),
                  _buildInfo('Date of Birth', 'Birthday'),
                  _buildInfo('Age', '25 years old'), 
                  Divider(height: 1, color: Colors.grey, indent: 40, endIndent: 40),
                  _buildInfo('Emergency Contact', 'Emergency Contact'),
                  _buildInfo('Contact Number', 'Contact Number'),
                  _buildInfo('Relationship', 'Relationship'),
                ],
              )
            ),
            const SizedBox(height: 10),
            _customContainer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  const Text(
                    'Qualifications',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  _buildInfo('Licensing Certificate Given', 'Professional Driver\'s\nLicense'),
                  _buildInfo('Licensing Certificate Photo', 'View'),
                  Divider(height: 1, color: Colors.grey, indent: 40, endIndent: 40),
                  _buildInfo('Barangay Certificate', 'View'),
                  Divider(height: 1, color: Colors.grey, indent: 40, endIndent: 40),
                  _buildInfo('Over 56', 'No'),
                  _buildInfo('PWD', 'No'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, Color bgColor) {
    return SizedBox(
      height: 24, 
      width: MediaQuery.of(context).size.width * 0.455,
      child: ElevatedButton(
        onPressed: !isLoading
          ? () {
              setState(() {
                worker['is_certified'] = label == 'Accept' 
                  ? 'ongoing' 
                  : 'denied';
              });
              updateCertification();
            }
          : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)) 
        ),
        child: Text(
          label, 
          style: TextStyle(
            color: Colors.white,
            fontSize: 16
          ),
        ),
      )
    );
  }

  Widget _buildButtonLong(String label, Color bgColor) {
    return SizedBox(
      height: 24, 
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !isLoading
          ? () {
              setState(() {
            worker['is_certified'] = 'pending';
          });
          updateCertification();
          }
          : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)) 
        ),
        child: Text(
          label, 
          style: TextStyle(
            color: Colors.white,
            fontSize: 16
          ),
        ),
      )
    );
  }

  Widget _buildInfo(String label, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label, overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey[800])
        ),
        Text(
          data, textAlign: TextAlign.right, overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _customContainer(Widget child) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white.withAlpha(10)
      ),
      child: child
    );
  }
}