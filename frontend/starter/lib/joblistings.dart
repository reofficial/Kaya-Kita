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
        throw Exception('Failed to load jobs (Status: ${response.statusCode})');
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => JobInfoScreen(jobId: jobId)),
        );
      },
      borderRadius: BorderRadius.circular(16), // Match the card's border radius
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        child: Row(
          children: [
            Container(
              width: 120,
              height: 100,
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(16)),
                color: Colors.grey,
              ),
              child: const Icon(Icons.work, color: Colors.white, size: 40),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF87027B),
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (tags.isNotEmpty)
                      Wrap(
                        spacing: 1,
                        children: tags
                            .map((tag) => Chip(
                                  label: Text(tag,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.purpleAccent,
                                  padding: const EdgeInsets.all(0),
                                ))
                            .toList(),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Salary: PHP ${salary.toString()} / $salaryFrequency',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    // !! the following are hidden details but are accessible here:
                    /*
                  const SizedBox(height: 4),
                  Text(
                    'Duration: $duration',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Job ID: $jobId',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  */
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
