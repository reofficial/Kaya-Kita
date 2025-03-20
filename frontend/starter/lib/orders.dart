import 'package:flutter/material.dart';
import 'package:starter/api_service.dart';
import 'package:starter/completedjob.dart';
import 'package:starter/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<List<Map<String, dynamic>>> jobsFuture;
  late String currentUsername;
  List<Map<String, dynamic>> jobsData = [];

  @override
  void initState() {
    super.initState();
    currentUsername = Provider.of<UserProvider>(context, listen: false).username;
    jobsFuture = fetchUserJobs(currentUsername);
  }

  Future<List<Map<String, dynamic>>> fetchUserJobs(String currentUsername) async {
    try {
      final response = await ApiService.getJobCircles();
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> userJobs = data
            .where((job) => job['customer'] == currentUsername)
            .map((job) => {
                  'ticket_number': job['ticket_number'],
                  'datetime': job['datetime'],
                  'customer': job['customer'],
                  'handyman': job['handyman'],
                  'job_status': job['job_status'],
                  'payment_status': job['payment_status'],
                  'rating_status': job['rating_status'],
                })
            .toList();
        jobsData = userJobs;
        return userJobs;
      } else {
        throw Exception("Failed to load jobs (Status: ${response.statusCode})");
      }
    } catch (e) {
      throw Exception("Error fetching jobs: $e");
    }
  }

  void refreshOrders() {
    setState(() {
      jobsFuture = fetchUserJobs(currentUsername);
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
                  "Pending Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...jobs
                    .where((job) => job["job_status"] == "Pending")
                    .map((job) => JobCircles(
                          job: job,
                          onRated: () {
                            setState(() {
                              job['rating_status'] = 'Rated';
                            });
                          },
                        )),
                const SizedBox(height: 15),
                const Text(
                  "Ongoing Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...jobs
                    .where((job) =>
                        job["job_status"] == "Ongoing" ||
                        job["job_status"] == "Accepted")
                    .map((job) => JobCircles(
                          job: job,
                          onRated: () {
                            setState(() {
                              job['rating_status'] = 'Rated';
                            });
                          },
                        )),
                const SizedBox(height: 15),
                const Text(
                  "Completed Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...jobs
                    .where((job) => job["job_status"] == "Completed")
                    .map((job) => JobCircles(
                          job: job,
                          onRated: () {
                            setState(() {
                              job['rating_status'] = 'Rated';
                            });
                          },
                        )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class JobCircles extends StatelessWidget {
  const JobCircles({
    super.key,
    required this.job,
    required this.onRated,
  });

  final Map<String, dynamic> job;
  final VoidCallback onRated;

  @override
  Widget build(BuildContext context) {
    final int ticketNumber = job["ticket_number"];
    final String datetime = job["datetime"];
    final String customer = job["customer"];
    final String handyman = job["handyman"];
    final String jobStatus = job["job_status"];
    final String paymentStatus = job["payment_status"];
    final String ratingStatus = job["rating_status"];

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: InkWell(
        onTap: () async {
          if (jobStatus == 'Completed' && ratingStatus == 'Unrated') {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompletedJobScreen(
                  ticketNumber: ticketNumber,
                  datetime: datetime,
                  customer: customer,
                  handyman: handyman,
                  jobStatus: jobStatus,
                  paymentStatus: paymentStatus,
                ),
              ),
            );
            if (result == 'Rated') {
              onRated();
            }
          } else if (jobStatus == 'Completed' && ratingStatus == 'Rated') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Already provided rating."),
                backgroundColor: Colors.orange,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Cannot give ratings before job is finished"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ticket #$ticketNumber",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF87027B),
                ),
              ),
              const SizedBox(height: 4),
              Text("Date: $datetime"),
              const SizedBox(height: 4),
              Text("Customer: $customer"),
              const SizedBox(height: 4),
              Text("Handyman: $handyman"),
              const SizedBox(height: 4),
              Text("Job Status: $jobStatus"),
              const SizedBox(height: 4),
              Text("Payment Status: $paymentStatus"),
              const SizedBox(height: 4),
              Text("Rating Status: $ratingStatus"),
            ],
          ),
        ),
      ),
    );
  }
}
