import 'package:flutter/material.dart';
import 'package:starter/jobinfo.dart';
import 'dart:convert';

import 'package:starter/widgets/customappbar.dart';
import 'package:starter/newpost.dart';
import 'package:starter/api_service.dart';

class JobListingsScreen extends StatefulWidget {
  const JobListingsScreen({super.key});

  @override
  State<JobListingsScreen> createState() => _JobListingsScreenState();
}

class _JobListingsScreenState extends State<JobListingsScreen> {
  late Future<List<Map<String, dynamic>>> jobsFuture;

  Future<List<Map<String, dynamic>>> fetchJobListings() async {
    try {
      final response = await ApiService.getJobListings();
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((item) => {
                  'job_id': item['job_id'] ?? -1,
                  'tags': (item['tag'] as List<dynamic>?)
                          ?.map((tag) => tag?.toString() ?? 'N/A')
                          .toList() ??
                      [],
                  'title': item['job_title']?.toString() ?? 'No Title',
                  'description':
                      item['description']?.toString() ?? 'No Description',
                  'location': item['location']?.toString() ?? 'No Location',
                  'salary': item['salary'] ?? -1.0,
                  'salaryFrequency':
                      item['salary_frequency']?.toString() ?? 'N/A',
                  'duration': item['duration']?.toString() ?? 'N/A',
                })
            .toList();
      } else {
        throw Exception(
            'Failed to load jobs (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching jobs: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    jobsFuture = fetchJobListings();
  }

  void refreshJobListings() {
    setState(() {
      jobsFuture = fetchJobListings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(titleText: 'Job Listings'),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: jobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('An error occurred while loading jobs.'),
                  const SizedBox(height: 8),
                  Text('${snapshot.error}',
                      style: const TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: refreshJobListings,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final jobs = snapshot.data!;
            return RefreshIndicator(
              onRefresh: () async => refreshJobListings(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return JobListing(
                    jobId: job['job_id'] ?? 0,
                    tags: job['tags'] ?? [],
                    title: job['title'],
                    description: job['description'],
                    location: job['location'],
                    salary: job['salary'] ?? 0,
                    salaryFrequency: job['salaryFrequency'],
                    duration: job['duration'],
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('No job listings available.'));
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle,
                  size: 50, color: Color(0xFF87027B)),
              onPressed: () async {
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewPostScreen()),
                );
                refreshJobListings();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class JobListing extends StatelessWidget {
  const JobListing({
    super.key,
    required this.jobId,
    required this.tags,
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
    required this.salaryFrequency,
    required this.duration,
  });

  final int jobId;
  final List<String> tags;
  final String title;
  final String description;
  final String location;
  final double salary;
  final String salaryFrequency;
  final String duration;

  // Helper method to return an image based on the first tag/category.
  ImageProvider _getCategoryImage() {
    if (tags.isNotEmpty) {
      final category = tags.first.toLowerCase();
      switch (category) {
        case 'technology':
          return const AssetImage('assets/Technology.png');
        case 'business':
          return const AssetImage('assets/Business.png');
        case 'construction':
          return const AssetImage('assets/construction.png');
        case 'education':
          return const AssetImage('assets/education.png');
        case 'entertainment':
          return const AssetImage('assets/Entertainment.png');
        // Add other cases as needed...
        default:
          return const AssetImage('assets/Default.png');
      }
    } else {
      return const AssetImage('assets/Default.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, // Ensures corners are clipped
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => JobInfoScreen(jobId: jobId)),
          );
        },
        child: Row(
          children: [
            // Left: image with a fixed size and cover.
            Image(
              image: _getCategoryImage(),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title styled in purple.
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF87027B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Category chips styled in purple.
                    if (tags.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        children: tags
                            .map((tag) => Chip(
                                  label: Text(
                                    tag,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor:
                                      const Color(0xFF87027B),
                                ))
                            .toList(),
                      ),
                    const SizedBox(height: 4),
                    // Location row with icon.
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: Color(0xFF87027B)),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Salary row with icon.
                    Row(
                      children: [
                        const Icon(Icons.attach_money,
                            size: 14, color: Color(0xFF87027B)),
                        const SizedBox(width: 4),
                        Text(
                          '$salary / $salaryFrequency',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
