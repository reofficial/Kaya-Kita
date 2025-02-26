import 'dart:convert';
import 'package:flutter/material.dart';
import 'api_service.dart'; // Ensure the correct import path
import 'viewpost.dart';

// Updated JobListing model with a factory constructor
class JobListing {
  final String title;
  final String description;
  final String customer;
  final String address;
  final String postedDate;
  final String rate;
  String status;

  JobListing({
    required this.title,
    required this.description,
    required this.customer,
    required this.address,
    required this.postedDate,
    required this.rate,
    required this.status,
  });

  factory JobListing.fromJson(Map<String, dynamic> json) {
    return JobListing(
      title: json['job_title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      customer: json['customer'] ?? 'Unknown', // Adjust based on your API response
      address: json['location'] ?? 'No Address',
      postedDate: json['posted_date'] ?? 'N/A',
      rate: json['salary'] != null && json['salary_frequency'] != null
          ? '${json['salary']}/${json['salary_frequency']}'
          : 'N/A',
      status: json['status'] ?? '',
    );
  }
}

class JobListingsScreen extends StatefulWidget {
  const JobListingsScreen({Key? key}) : super(key: key);

  @override
  State<JobListingsScreen> createState() => _JobListingsScreenState();
}

class _JobListingsScreenState extends State<JobListingsScreen> {
  late Future<List<JobListing>> _jobListingsFuture;

  @override
  void initState() {
    super.initState();
    _jobListingsFuture = fetchJobListings();
  }

  Future<List<JobListing>> fetchJobListings() async {
    final response = await ApiService.getJobListings();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => JobListing.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load job listings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Job Listings', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF000E53),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<JobListing>>(
        future: _jobListingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No job listings available."));
          } else {
            final jobListings = snapshot.data!;
            return ListView.builder(
              itemCount: jobListings.length,
              itemBuilder: (context, index) {
                return JobListingCard(job: jobListings[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class JobListingCard extends StatefulWidget {
  final JobListing job;
  const JobListingCard({Key? key, required this.job}) : super(key: key);

  @override
  State<JobListingCard> createState() => _JobListingCardState();
}

class _JobListingCardState extends State<JobListingCard> {
  void updateStatus(String newStatus) {
    if (!(widget.job.status == 'Accepted' || widget.job.status == 'Denied')) {
      setState(() {
        widget.job.status = newStatus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.job.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000E53),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.job.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.person, color: Color(0xFF000E53)),
                const SizedBox(width: 8),
                Text(
                  widget.job.customer,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.redAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.job.address,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  widget.job.postedDate,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  widget.job.rate,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Actions based on job status
            if (widget.job.status == 'Accepted')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Accepted',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to the detailed view or job info screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewPostScreen()),
                      );
                    },
                    icon: const Icon(Icons.visibility, color: Colors.white),
                    label: const Text('View'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000E53),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              )
            else if (widget.job.status == 'Denied')
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.cancel, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Denied',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => updateStatus('Accepted'),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF00880C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Accept',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => updateStatus('Denied'),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF8D0010),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Deny',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
