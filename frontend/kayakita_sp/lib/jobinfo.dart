import 'package:flutter/material.dart';
import 'package:kayakita_sp/api_service.dart';
import 'dart:convert';
import 'package:kayakita_sp/joblistings.dart';
import 'package:provider/provider.dart';
import 'package:kayakita_sp/providers/profile_provider.dart';
import 'personalinfo2.dart';
import 'package:collection/collection.dart';

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
  String is_certified = '';
  String service_preference = '';
  String userEmail = '';
  String userPassword = '';
  String job_status = '';
  int job_id = 0;

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
          salary = job['salary'];
          salaryFrequency = job['salary_frequency'];
          duration = job['duration']; 
          job_status = job['job_status']; //inadd ko lang
          job_id = job['job_id'];
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
      final email = userProvider.email;

      print("Fetching certification for username: $username, email: $email"); 

      final response = await ApiService.getWorkers();
      if (response.statusCode == 200) {
        final List<dynamic> workers = json.decode(response.body);
        final worker = workers.firstWhere(
          (w) => w['username'] == username,
          orElse: () => null, 
        );

        if (worker != null) {
        final email = worker['email'] ?? "N/A"; 
        final password = worker['password'] ?? "N/A"; 
        final certStatus = worker['is_certified'] ?? "pending";
        final servicePreference = worker['service_preference'] ?? "None";

        print("Worker found - Email: $email, Password: $password, Cert Stat: $certStatus"); 

        setState(() {
          userEmail = email; 
          userPassword = password;
          is_certified = certStatus; 
          service_preference = servicePreference;
        });
      } else {
        print("No matching worker found for username: $username");
      }
    } else {
      print("API request failed with status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching worker certification: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to fetch worker certification: $e")),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserProvider>(context, listen: false).username;
    bool isServicePreferenceInJob = title.toLowerCase().contains(service_preference.toLowerCase()) ||
                                  description.toLowerCase().contains(service_preference.toLowerCase());

    print("Service Preference: $service_preference");
    print("Job Title: $title");
    print("Job Description: $description");
    print("Match Found: $isServicePreferenceInJob");

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
              onPressed: () async {
                if (isServicePreferenceInJob && is_certified == "pending") {
                  try {
                    await ApiService.updateJobListing({'job_id': job_id, 'job_status': 'accepted', 'worker_username': [username]}); 
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("You're already certified. Added you to queue instead.")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to update job status: $e")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill out all the relevant information.")),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondPersonalInfoScreen(email: userEmail, password: userPassword),
                    ),
                  );
                }
              },
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
