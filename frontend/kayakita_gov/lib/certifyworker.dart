import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    // _workersFuture = fetchWorkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certify Worker', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF000E53),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.18,
                child: Image.asset('assets/kamala.png'),
              ),
              SizedBox(height: 10),
              Text(
                widget.workerUsername, 
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
              ),
              Text('Applied on October 8, 2024'),
              SizedBox(height: 10),
              Text(
                'Not Certified',
                style: TextStyle(fontSize: 20)
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton('Deny', Colors.red),
                  _buildButton('Accept', Colors.green)
                ],
              ),

              SizedBox(height: 10),

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
                    _buildInfo('Age', '${widget.workerUsername} years old'),
                    Divider(height: 1, color: Colors.grey, indent: 40, endIndent: 40),
                    _buildInfo('Emergency Contact', 'Emergency Contact'),
                    _buildInfo('Contact Number', 'Contact Number'),
                    _buildInfo('Relationship', 'Relationship'),
                  ],
                ),
              ),
              SizedBox(height: 10),
              _customContainer(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    Text(
                      'Qualifications', 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
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
              )
            ],
          ),
        )
      )
    );
  }

  Widget _buildButton(String label, Color bgColor) {
    return SizedBox(
      height: 24, 
      width: MediaQuery.of(context).size.width * 0.455,
      child: ElevatedButton(
        onPressed: () {},
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