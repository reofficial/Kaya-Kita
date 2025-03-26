import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:kayakita_sp/api_service.dart';
// import 'package:kayakita_sp/home.dart';
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
  int jobId = 0;
  String authorUsername = '';
  List<dynamic> tags = [];
  String title = '';
  String description = '';
  String location = '';
  double salary = 0.0;
  String salaryFrequency = '';
  String duration = '';
  List<dynamic> workerUsername = [];
  String jobStatus = '';

  Map<String, dynamic>? contactDetails;

  String isCertified = '';
  String servicePreference = '';
  String userEmail = '';
  String userPassword = '';
  String denyReason = '';

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
          jobId = job['job_id'];
          authorUsername = job['username'];
          tags = job['tag'] ?? [];
          title = job['job_title'];
          description = job['description'];
          location = job['location'];
          salary = job['salary'].toDouble();
          salaryFrequency = job['salary_frequency'];
          duration = job['duration'];
          workerUsername = job['worker_username'];
          jobStatus = job['job_status'];
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
            isCertified = worker['is_certified'] ?? "pending";
            servicePreference = worker['service_preference'] ?? "None";
            denyReason = worker['deny_reason'] ?? "None";
          });
          // await fetchDenyReason();
        }
        print("Deny Reason: $denyReason");
      }
    } catch (e) {
      print("Failed to fetch worker certification: $e");
    }
  }

  // Future<void> fetchDenyReason() async {
  //   try {
  //     final response = await ApiService.getSecondJob();
  //     if (response.statusCode == 200) {
  //       final List<dynamic> jobs = json.decode(response.body);

  //       // Find job entry where email matches userEmail
  //       final job = jobs.firstWhere(
  //         (j) => j['email'] == userEmail,
  //         orElse: () => null,
  //       );

  //       if (job != null) {
  //         setState(() {
  //           deny_reason = job['deny_reason'] ?? "None";
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print("Failed to fetch deny reason: $e");
  //   }
  // }

  Future<void> applyToJob() async {
    final username = Provider.of<UserProvider>(context, listen: false).username;

    fetchJobListing(); // ** IMPORTANT: REFETCH JOB LISTING TO CHECK IF JOB STATUS CHANGED

    // ** Cancel applyToJob if 'job_status' is not open to applications.
    if (jobStatus.toLowerCase() != "pending" &&
        jobStatus.toLowerCase() != "accepted") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Failed to apply: Job listing has already closed.")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const JobListingsScreen()),
      );
      return;
    }

    // print("Deny Reason: $deny_reason");
    if (denyReason.toLowerCase() == "expired") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Certification Expired"),
          content: const Text("Certification expired. Please renew it."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Okay"),
            ),
          ],
        ),
      );
      return;
    }

    bool isServicePreferenceInJob =
        title.toLowerCase().contains(servicePreference.toLowerCase()) ||
            description.toLowerCase().contains(servicePreference.toLowerCase());

    // print("Service Preference: $service_preference");
    // print("Job Title: $title");
    // print("Job Description: $description");
    // print("Match Found: $isServicePreferenceInJob");

    if (isServicePreferenceInJob && isCertified == "certified") {
      try {
        workerUsername.add(username);
        final response = await ApiService.updateJobListing({
          'job_id': jobId,
          'job_status': 'accepted',
          'worker_username': workerUsername,
        });
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "You're already certified. Added you to queue instead.")),
          );
        }
        return;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to apply: $e")),
        );
        return;
      }
    }

    // ** CHECK IF JOB CATEGORY REQUIRES CERTIFICATION
    bool requiresCertification() {
      if (tags.isEmpty) return false;
      final checkTags = ["Construction", "Health", "Transport"];
      return tags.any((tag) => checkTags.contains(tag));
    }

    if (!requiresCertification()) {
      try {
        workerUsername.add(username);
        final response = await ApiService.updateJobListing({
          'job_id': jobId,
          'job_status': 'accepted',
          'worker_username': workerUsername,
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
      if (isCertified == "certified") {
        try {
          workerUsername.add(username);
          final response = await ApiService.updateJobListing({
            'job_id': jobId,
            'job_status': 'accepted',
            'worker_username': workerUsername,
          });
          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Application submitted successfully")),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const JobListingsScreen()),
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
            builder: (context) => PersonalCertificationInfoScreen(
                email: userEmail, password: userPassword),
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
              MaterialPageRoute(
                  builder: (context) => const JobListingsScreen()),
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
            Text(authorUsername,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(description),
                  const SizedBox(height: 12),
                  Text(
                      'Ideal Rate: ₱${salary.toStringAsFixed(2)}/$salaryFrequency',
                      style: const TextStyle(color: Colors.green)),
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
                    const Text('About Customer',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(contactDetails!['email'] ?? ''),
                    Text(contactDetails!['address'] ?? ''),
                    Text(
                        'Booked ${contactDetails!['book_count'] ?? 0} services so far'),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: applyToJob,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF87027B),
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text('Apply',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
