import 'package:flutter/material.dart';
import 'package:starter/api_service.dart';
import 'dart:convert';

import 'package:starter/jobedit.dart';

import 'package:provider/provider.dart';
import 'package:starter/joblistings.dart';
import 'package:starter/providers/profile_provider.dart';

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
  late String username; // username of current user

  List<dynamic> tag = [];
  String authorUsername = ''; // username of post author
  String title = '';
  String description = '';
  String location = '';
  double salary = 0.0;
  String salaryFrequency = '';
  String duration = '';

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
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching Job Listing: $e")),
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
          MaterialPageRoute(
            builder: (context) => JobListingsScreen(),
          ),
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
                        title: Text('Job Information'),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        toolbarHeight: 80,
                        // leading: IconButton(
                        //   icon: Icon(Icons.arrow_back),
                        //   onPressed: () {
                        //     Navigator.pop(context); // Goes back to the previous screen
                        //   },
                        // )
                      ),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    left: MediaQuery.of(context).size.width / 2 - 60,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/kamala.png'),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Job #${widget.jobId}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF87027B)),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey[500]!,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      description,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Ideal Rate: $salary/$salaryFrequency',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF00880C)),
                                    ),
                                    Text(
                                      'Duration: $duration',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Location: $location',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 0, right: 8),
                                  child: Text(
                                    'Submitted on 6 Dec, 2024 - 4:56 PM',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Divider(),
                              SizedBox(height: 8),
                              Text(
                                'Contact Me!',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.email, color: Colors.grey),
                                      SizedBox(width: 8),
                                      Text('kdharris@up.edu.ph'),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Colors.grey),
                                      SizedBox(width: 8),
                                      Text('UP Diliman, Quezon City'),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle,
                                          color: Colors.grey),
                                      SizedBox(width: 8),
                                      Text('Booked 48 services so far'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 28,
                      left: MediaQuery.of(context).size.width / 2 - 70,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            authorUsername,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.verified,
                              color: Color(0xFF87027B), size: 20),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (username == authorUsername) // Add this condition
                            ElevatedButton(
                              onPressed: deleteJobListing,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF870202),
                                foregroundColor: Colors.white,
                              ),
                              child: Text('Delete Post'),
                            ),
                          if (username == authorUsername) // Add this condition
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        JobEditScreen(jobId: widget.jobId),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF87027B),
                                foregroundColor: Colors.white,
                              ),
                              child: Text('Edit Post'),
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

    path.quadraticBezierTo(curveStartX - roundness / 2, startY, curveStartX,
        startY - roundness / 2);

    path.quadraticBezierTo(
        // main curve
        controlX,
        controlY,
        curveEndX,
        startY - roundness / 2);

    path.quadraticBezierTo(
        //trasnition curve
        curveEndX + roundness / 2,
        startY,
        curveEndX + roundness,
        startY);

    path.lineTo(endX, startY);
    path.lineTo(endX, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
