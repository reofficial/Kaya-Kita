import 'package:flutter/material.dart';
import 'package:starter/api_service.dart';
import 'dart:convert';
import 'package:starter/jobedit.dart';
import 'package:provider/provider.dart';
import 'package:starter/joblistings.dart';
import 'package:starter/providers/profile_provider.dart';
import 'package:starter/jobapplicants.dart';

class JobInfoScreen extends StatefulWidget {
  const JobInfoScreen({
    super.key,
    required this.jobId,
  });

  final int jobId;

  @override
  State<JobInfoScreen> createState() => _JobInfoScreenState();
}

class _JobInfoScreenState extends State<JobInfoScreen> {
  late String username;
  List<dynamic> tag = [];
  String authorUsername = '';
  String title = '';
  String description = '';
  String location = '';
  double salary = 0.0;
  String salaryFrequency = '';
  String duration = '';
  Map<String, dynamic>? contactDetails;

  @override
  void initState() {
    super.initState();
    fetchJobListing();
  }

  Future<void> fetchJobListing() async {
    try {
      final response = await ApiService.getJobListing(widget.jobId);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jobListing = json.decode(response.body)[0];
        setState(() {
          tag = jobListing['tag'];
          authorUsername = jobListing['username'];
          title = jobListing['job_title'];
          description = jobListing['description'];
          location = jobListing['location'];
          salary = jobListing['salary'];
          salaryFrequency = jobListing['salary_frequency'];
          duration = jobListing['duration'];
        });
        await fetchContactDetails();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching Job Listing: $e")),
      );
    }
  }

  Future<void> fetchContactDetails() async {
    try {
      final response = await ApiService.getCustomers();
      if (response.statusCode == 200) {
        final List<dynamic> customers = json.decode(response.body);
        final matchingCustomer = customers.firstWhere(
          (customer) => customer['username'] == authorUsername,
          orElse: () => null,
        );
        if (matchingCustomer != null) {
          setState(() {
            contactDetails = matchingCustomer;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching contact details: $e")),
      );
    }
  }

  Future<void> deleteJobListing() async {
    try {
      final response = await ApiService.deleteJobListing(widget.jobId);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Job Listing deleted successfully.")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => JobListingsScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting Job Listing: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    username = Provider.of<UserProvider>(context, listen: false).username;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipPath(
                    clipper: CurvedAppBar(),
                    child: Container(
                      height: 185,
                      color: Color(0xFF00880C),
                      child: AppBar(
                        centerTitle: true,
                        title: Text('Job Information'),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        toolbarHeight: 80,
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    left: MediaQuery.of(context).size.width / 2 - 60,
                    child: CircleAvatar(
                      radius: 60,
                      child: Icon(Icons.person, size: 60),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Card(
                        margin: EdgeInsets.only(top: 60, left: 16, right: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    Text('Job #${widget.jobId}',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF87027B))),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              SizedBox(
                                width: 300,
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[500]!, width: 1.5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(description, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 8),
                                      Text('Ideal Rate: $salary/$salaryFrequency',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF00880C))),
                                      Text('Duration: $duration', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                      Text('Location: $location', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Divider(),
                              SizedBox(height: 8),
                              contactDetails != null
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Contact Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.person, color: Colors.grey),
                                            SizedBox(width: 8),
                                            Text(contactDetails!['name'] ?? contactDetails!['username'] ?? ''),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.email, color: Colors.grey),
                                            SizedBox(width: 8),
                                            Text(contactDetails!['email'] ?? ''),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.phone, color: Colors.grey),
                                            SizedBox(width: 8),
                                            Text(contactDetails!['contact_number'] ?? ''),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on, color: Colors.grey),
                                            SizedBox(width: 8),
                                            Text(location),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Text('No contact details available'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 28,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(authorUsername, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(width: 6),
                            Icon(Icons.verified, color: Color(0xFF87027B), size: 20),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          if (username == authorUsername)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobApplicantsScreen(jobId: widget.jobId),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF87027B),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Text('View Applicants', style: TextStyle(fontSize: 16)),
                            ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (username == authorUsername)
                                ElevatedButton(
                                  onPressed: deleteJobListing,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF870202),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  child: Text('Delete Post', style: TextStyle(fontSize: 16)),
                                ),
                              if (username == authorUsername)
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => JobEditScreen(
                                          jobId: widget.jobId,
                                          isEditMode: true,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF00880C),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  child: Text('Edit Post', style: TextStyle(fontSize: 16)),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CurvedAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double startX = 0;
    double startY = size.height * 0.75;
    double curveStartX = size.width * 0.32;
    double curveEndX = size.width * 0.68;
    double endX = size.width;
    double controlX = size.width * 0.5;
    double controlY = size.height * 0.2;
    double roundness = size.width * 0.07;

    path.lineTo(startX, startY);
    path.lineTo(curveStartX - roundness, startY);
    path.quadraticBezierTo(curveStartX - roundness / 2, startY, curveStartX, startY - roundness / 2);
    path.quadraticBezierTo(controlX, controlY, curveEndX, startY - roundness / 2);
    path.quadraticBezierTo(curveEndX + roundness / 2, startY, curveEndX + roundness, startY);
    path.lineTo(endX, startY);
    path.lineTo(endX, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
