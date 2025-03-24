import 'package:flutter/material.dart';

class JobApplicantsScreen extends StatefulWidget {
  final int jobId;
  const JobApplicantsScreen({super.key, required this.jobId});

  @override
  State<JobApplicantsScreen> createState() => _JobApplicantsScreenState();
}

class _JobApplicantsScreenState extends State<JobApplicantsScreen> {
  final List<Map<String, String>> applicants = [
    {
      'name': 'Juan Dela Cruz',
      'email': 'juan@example.com',
      'contact': '09171234567',
    },
    {
      'name': 'Maria Santos',
      'email': 'maria@example.com',
      'contact': '09181234567',
    },
    {
      'name': 'Pedro Penduko',
      'email': 'pedro@example.com',
      'contact': '09192234567',
    },
  ];

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
      body: ListView.builder(
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
                    onPressed: () {},
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
