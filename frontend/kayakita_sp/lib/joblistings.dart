import 'package:flutter/material.dart';
import 'package:kayakita_sp/jobinfo.dart';
import 'dart:convert';
import 'package:kayakita_sp/api_service.dart';
import 'package:kayakita_sp/widgets/customappbar.dart';
import 'home.dart';
import 'package:kayakita_sp/providers/profile_provider.dart';
import 'package:provider/provider.dart';

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
            .where((item) => item['is_hidden'] != true)
            .map((item) => {
                  'job_id': item['job_id'] ?? -1,
                  'tags': (item['tag'] as List<dynamic>? ?? [])
                      .map((tag) => tag?.toString() ?? 'N/A')
                      .toList(),
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
      appBar: AppBar(
        title: const Text('Job Listings'),
        automaticallyImplyLeading: false,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       String email = Provider.of<UserProvider>(context, listen: false).email;
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => HomeScreen(email: email)),
      //       );
      //     },
      //   ),
      ),
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
                  Text('${snapshot.error}', style: const TextStyle(color: Colors.red)),
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

  ImageProvider _getCategoryImage() {
    if (tags.isNotEmpty) {
      final category = tags.first.toLowerCase();
      switch (category) {
        case 'technology':
          return const AssetImage('assets/Technology.png');
        case 'business':
          return const AssetImage('assets/Business.png');
        case 'entertainment':
          return const AssetImage('assets/Entertainment.png');
        case 'construction':
          return const AssetImage('assets/Construction.png');
        case 'education':
          return const AssetImage('assets/Education.png');
        case 'health':
          return const AssetImage('assets/Health.png');
        case 'housework':
          return const AssetImage('assets/Housework.png');
        case 'food':
          return const AssetImage('assets/Food.png');
        case 'transport':
          return const AssetImage('assets/Transport.png');
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
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JobInfoScreen(jobId: jobId)),
          );
        },
        child: Row(
          children: [
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
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF87027B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (tags.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        children: tags
                            .map((tag) => Chip(
                                  label: Text(
                                    tag,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: const Color(0xFF87027B),
                                ))
                            .toList(),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Color(0xFF87027B)),
                        const SizedBox(width: 4),
                        Text(location, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.attach_money, size: 14, color: Color(0xFF87027B)),
                        const SizedBox(width: 4),
                        Text(
                          '$salary / $salaryFrequency',
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
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
