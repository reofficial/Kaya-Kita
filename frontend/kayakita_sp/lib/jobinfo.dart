import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:kayakita_sp/api_service.dart';
import 'package:provider/provider.dart';
import 'package:kayakita_sp/providers/profile_provider.dart';
import 'personalinfo2.dart';
import 'joblistings.dart';

class JobInfoScreen extends StatefulWidget {
  final int jobId;
  const JobInfoScreen({super.key, required this.jobId});

  @override
  State<JobInfoScreen> createState() => _JobInfoScreenState();
}

class _JobInfoScreenState extends State<JobInfoScreen> {
  String authorUsername = '';
  String title = '';
  String description = '';
  String location = '';
  double salary = 0.0;
  String salaryFrequency = '';
  String duration = '';
  Map<String, dynamic>? contactDetails;
  List<dynamic> tags = [];
  int job_id = 0;

  String is_certified = '';
  String service_preference = '';
  String userEmail = '';
  String userPassword = '';

  @override
  void initState() {
    super.initState();
    fetchJobListing();
    fetchWorkerCertification();
  }

  Future<void> fetchJobListing() async {
    try {
      final response = await ApiService.getJobListing(widget.jobId);
      if (response.statusCode == 200) {
        final Map<String, dynamic> job = json.decode(response.body)[0];
        setState(() {
          authorUsername = job['username'];
          title = job['job_title'];
          description = job['description'];
          location = job['location'];
          salary = job['salary'].toDouble();
          salaryFrequency = job['salary_frequency'];
          duration = job['duration'];
          job_id = job['job_id'];
          tags = job['tag'] ?? [];
        });
        fetchContactDetails();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch job: $e")),
      );
    }
  }

  Future<void> fetchContactDetails() async {
    try {
      final response = await ApiService.getCustomers();
      if (response.statusCode == 200) {
        final List<dynamic> customers = json.decode(response.body);
        final customer = customers.firstWhere(
          (cust) => cust['username'] == authorUsername,
          orElse: () => null,
        );
        if (customer != null) {
          setState(() {
            contactDetails = customer;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch customer: $e")),
      );
    }
  }

  Future<void> fetchWorkerCertification() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final username = userProvider.username;
      final response = await ApiService.getWorkers();
      if (response.statusCode == 200) {
        final List<dynamic> workers = json.decode(response.body);
        final worker = workers.firstWhere(
          (w) => w['username'] == username,
          orElse: () => null,
        );

        if (worker != null) {
          setState(() {
            userEmail = worker['email'] ?? '';
            userPassword = worker['password'] ?? '';
            is_certified = worker['is_certified'] ?? "pending";
            service_preference = worker['service_preference'] ?? "None";
          });
        }
      }
    } catch (e) {
      print("Failed to fetch worker certification: $e");
    }
  }

  bool isFreelanceCategory() {
    if (tags.isEmpty) return false;
    final freelanceTags = ["entertainment", "housework", "food"];
    return freelanceTags.contains(tags.first.toString().toLowerCase());
  }

  Future<void> applyToJob() async {
    final username = Provider.of<UserProvider>(context, listen: false).username;

    if (isFreelanceCategory()) {
      try {
        final response = await ApiService.updateJobListing({
          'job_id': job_id,
          'job_status': 'accepted',
          'worker_username': [username],
        });
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Application submitted successfully")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const JobListingsScreen()),
          );
        } else {
          throw Exception('Failed to update job listing');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to apply: $e")),
        );
      }
    } else {
      if (is_certified == "certified") {
        try {
          final response = await ApiService.updateJobListing({
            'job_id': job_id,
            'job_status': 'pending',
            'worker_username': [username],
          });
          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Application submitted successfully")),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const JobListingsScreen()),
            );
          } else {
            throw Exception('Failed to update job listing');
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to apply: $e")),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonalCertificationInfoScreen(email: userEmail, password: userPassword),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Job Information'),
        backgroundColor: const Color(0xFF00880C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const JobListingsScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/reviewprofile.png'),
            ),
            const SizedBox(height: 8),
            Text(authorUsername, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Icon(Icons.verified, color: Color(0xFF87027B), size: 18),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(description),
                  const SizedBox(height: 12),
                  Text('Ideal Rate: ₱${salary.toStringAsFixed(2)}/$salaryFrequency', style: const TextStyle(color: Colors.green)),
                  Text('Duration: $duration'),
                  Text('Location: $location'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (contactDetails != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('About Customer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(contactDetails!['email'] ?? ''),
                    Text(contactDetails!['address'] ?? ''),
                    Text('Booked ${contactDetails!['book_count'] ?? 0} services so far'),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: applyToJob,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF87027B),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text('Apply', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
