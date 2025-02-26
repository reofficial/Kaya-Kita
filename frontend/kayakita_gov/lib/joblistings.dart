import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'api_service.dart';
// import 'viewpost.dart';

class JobListing {
  JobListing({
    required this.id,
    required this.author,
    required this.title,
    required this.description,
    required this.address,
    required this.salary,
    required this.frequency,
    required this.duration,
    this.status = "No issues detected", // Default status
  });

  final int id;
  final String author;
  final String title;
  final String description;
  final String address;
  final double salary;
  final String frequency;
  final String duration;
  String status;

  factory JobListing.fromJson(Map<String, dynamic> job) {
    return JobListing(
      id: job['job_id'],
      title: job['job_title'],
      description: job['description'],
      author: job['username'],
      address: job['location'],
      salary: job['salary'],
      frequency: job['salary_frequency'],
      duration: job['duration'],
    );
  }
}

Future<List<JobListing>> fetchJobListings() async {
  final response = await ApiService.getJobListings();
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    List<JobListing> jobListings =
        data.map((item) => JobListing.fromJson(item)).toList();
    List<RegExp> profanityPatterns = await loadProfanityPatterns();
    for (var job in jobListings) {
      job.status = deriveStatus(job, profanityPatterns, jobListings);
    }
    return sortJobListings(jobListings);
  } else {
    throw Exception('Failed to load job listings');
  }
}

Future<List<RegExp>> loadProfanityPatterns() async {
  try {
    // Load the file from the assets
    String fileContents = await rootBundle.loadString('assets/badwords.txt');
    // Split the file contents into lines and trim any whitespace
    List<String> lines =
        fileContents.split('\n').map((line) => line.trim()).toList();
    // Remove any empty lines
    lines.removeWhere((line) => line.isEmpty);
    // Compile each line into a RegExp object
    List<RegExp> patterns =
        lines.map((line) => RegExp(line, caseSensitive: false)).toList();
    return patterns;
  } catch (e) {
    return []; // Return an empty list if there's an error
  }
}

bool containsProfanity(String text, List<RegExp> profanityPatterns) {
  return profanityPatterns.any((pattern) => pattern.hasMatch(text));
}

bool isPotentialDuplicate(JobListing currentJob, List<JobListing> allJobs) {
  return allJobs.any((job) =>
      job.id != currentJob.id &&
      (job.title.toLowerCase() == currentJob.title.toLowerCase() ||
          job.description.toLowerCase() ==
              currentJob.description.toLowerCase()));
}

String deriveStatus(
    JobListing job, List<RegExp> profanityPatterns, List<JobListing> allJobs) {
  if (containsProfanity(job.description, profanityPatterns)) {
    return "Contains profanity";
  } else if (isPotentialDuplicate(job, allJobs)) {
    return "Maybe duplicate";
  } else {
    return "No issues detected";
  }
}

List<JobListing> sortJobListings(List<JobListing> jobListings) {
  const statusPriority = {
    "Contains profanity": 1,
    "Maybe duplicate": 2,
    "No issues detected": 3,
  };

  jobListings.sort((a, b) {
    int priorityA = statusPriority[a.status] ?? 3; // Default to lowest priority
    int priorityB = statusPriority[b.status] ?? 3; // Default to lowest priority
    return priorityA.compareTo(priorityB);
  });

  return jobListings;
}

class JobListingsScreen extends StatefulWidget {
  const JobListingsScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title:
            const Text('Job Listings', style: TextStyle(color: Colors.white)),
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
  const JobListingCard({super.key, required this.job});

  final JobListing job;

  @override
  State<JobListingCard> createState() => _JobListingCardState();
}

class _JobListingCardState extends State<JobListingCard> {
  Future<void> deleteJobListing() async {
    try {
      final response = await ApiService.deleteJobListing(widget.job.id);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Job Listing deleted successfully.")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => JobListingsScreen(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting Job Listing: $e")),
      );
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
                  widget.job.author,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
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
                const Icon(Icons.attach_money, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  "${widget.job.salary} ${widget.job.frequency}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: widget.job.status == "No issues detected"
                          ? Colors.green
                          : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.job.status,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: widget.job.status == "No issues detected"
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ],
                ),
                if (widget.job.status != "No issues detected")
                  ElevatedButton.icon(
                    onPressed: deleteJobListing,
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    label: const Text('Reject'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
