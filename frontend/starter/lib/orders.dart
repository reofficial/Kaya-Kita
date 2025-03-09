import 'package:flutter/material.dart';
import 'package:starter/api_service.dart';
import 'package:starter/jobedit.dart';
import 'package:provider/provider.dart';
import 'package:starter/providers/profile_provider.dart';
import 'dart:convert';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<List<Map<String, dynamic>>> jobsFuture;

  @override
  void initState() {
    super.initState();
    jobsFuture = fetchUserJobs();
  }

  Future<List<Map<String, dynamic>>> fetchUserJobs() async {
    try {
      final response = await ApiService.getJobListings();
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Get the logged-in username
        String currentUsername = Provider.of<UserProvider>(context, listen: false).username;

        List<Map<String, dynamic>> userJobs = data
            .where((job) => job['username'] == currentUsername)
            .map((job) => {
                  'job_id': job['job_id'],
                  'tags': job['tag'] ?? [],
                  'title': job['job_title'],
                  'description': job['description'],
                  'location': job['location'],
                  'salary': job['salary'],
                  'salaryFrequency': job['salary_frequency'],
                  'duration': job['duration'],
                  'status': (job['is_completed'] != null && job['is_completed'] == true) 
                              ? "Completed" 
                              : "Ongoing",
                })
            .toList();

        return userJobs;
      } else {
        throw Exception("Failed to load jobs (Status: ${response.statusCode})");
      }
    } catch (e) {
      print("Error fetching jobs: $e");
      throw Exception("Error fetching jobs: $e");
    }
  }

  void refreshOrders() {
    setState(() {
      jobsFuture = fetchUserJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF87027B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: jobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          final jobs = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async => refreshOrders(),
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const Text(
                  "Ongoing Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...jobs
                    .where((job) => job["status"] == "Ongoing")
                    .map((job) => JobListing(
                          jobId: job["job_id"],
                          tags: List<String>.from(job["tags"]),
                          title: job["title"],
                          description: job["description"],
                          location: job["location"],
                          salary: job["salary"],
                          salaryFrequency: job["salaryFrequency"],
                          duration: job["duration"],
                        ))
                    .toList(),
                const SizedBox(height: 15),
                const Text(
                  "Completed Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...jobs
                    .where((job) => job["status"] == "Completed")
                    .map((job) => JobListing(
                          jobId: job["job_id"],
                          tags: List<String>.from(job["tags"]),
                          title: job["title"],
                          description: job["description"],
                          location: job["location"],
                          salary: job["salary"],
                          salaryFrequency: job["salaryFrequency"],
                          duration: job["duration"],
                        ))
                    .toList(),
              ],
            ),
          );
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobEditScreen(
                jobId: jobId,
                isEditMode: true, 
              ),
            ),
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
                        const Icon(Icons.location_on,
                            size: 14, color: Color(0xFF87027B)),
                        const SizedBox(width: 4),
                        Text(location),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.attach_money,
                            size: 14, color: Color(0xFF87027B)),
                        const SizedBox(width: 4),
                        Text('$salary / $salaryFrequency'),
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