import 'package:flutter/material.dart';
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
        return data.map((item) => item as Map<String, dynamic>).toList();
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
                    title: job['job_title'] ?? 'No Title',
                    description: job['description'] ?? 'No Description',
                    location: job['location'] ?? 'No Location',
                    salary: job['salary'] ?? 0,
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
                await Navigator.push(
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
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
  });

  final String title;
  final String description;
  final String location;
  final double salary;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: Row(
        children: [
          Container(
            width: 120,
            height: 100,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
                    'Salary: PHP $salary',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
