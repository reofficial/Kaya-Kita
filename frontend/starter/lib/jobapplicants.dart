import 'package:flutter/material.dart';
import 'dart:convert';
import 'api_service.dart';

class JobApplicantsScreen extends StatefulWidget {
  final int jobId;
  const JobApplicantsScreen({super.key, required this.jobId});

  @override
  State<JobApplicantsScreen> createState() => _JobApplicantsScreenState();
}

class _JobApplicantsScreenState extends State<JobApplicantsScreen> {
  List<Map<String, String>> applicants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchApplicants();
  }

  Future<void> fetchApplicants() async {
    try {
      final response = await ApiService.getJobListings();
      if (response.statusCode != 200) throw Exception('Failed to load jobs');

      List<dynamic> jobData = json.decode(response.body);
      final job = jobData.firstWhere(
        (job) => job['job_id'] == widget.jobId,
        orElse: () => null,
      );

      if (job == null) throw Exception('Job not found');

      List<String> workerUsernames = List<String>.from(job['worker_username']);
      final workerResponse = await ApiService.getWorkers();
      if (workerResponse.statusCode != 200) throw Exception('Failed to load workers');

      List<dynamic> workersData = json.decode(workerResponse.body);
      List<Map<String, String>> fetchedApplicants = [];

      for (String username in workerUsernames) {
        final worker = workersData.firstWhere(
          (worker) => worker['username'] == username,
          orElse: () => null,
        );
        if (worker != null) {
          fetchedApplicants.add({
            'name': '${worker['first_name']} ${worker['last_name']}',
            'username': username,
            'email': worker['email'],
            'contact': worker['contact_number'],
          });
        }
      }

      setState(() {
        applicants = fetchedApplicants;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching applicants: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Applicants'),
        backgroundColor: const Color(0xFF87027B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : applicants.isEmpty
              ? const Center(
                  child: Text(
                    'No applicants yet. Check back soon!',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: applicants.length,
                  itemBuilder: (context, index) {
                    final applicant = applicants[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(applicant['name']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.person, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(applicant['username']!),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.email, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(applicant['email']!),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.phone, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(applicant['contact']!),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  print('Sending Request:');
                                  print('job_id: ${widget.jobId}');
                                  print('job_status: ongoing');
                                  print('worker_username: ${[applicant['username']]}');

                                  final response = await ApiService.updateJobListing({
                                    'job_id': widget.jobId,
                                    'job_status': 'ongoing',
                                    'worker_username': [applicant['username']],
                                  });

                                  print('Response Code: ${response.statusCode}');
                                  print('Response Body: ${response.body}');

                                  if (response.statusCode == 200) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Worker accepted successfully')),
                                    );
                                    fetchApplicants();
                                  } else {
                                    throw Exception('Failed to update job listing: ${response.body}');
                                  }
                                } catch (error) {
                                  print('Error updating job listing: $error');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $error')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF87027B),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Accept Applicant'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
