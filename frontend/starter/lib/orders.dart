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

  @override
  void initState() {
    super.initState();
    currentUsername =
        Provider.of<UserProvider>(context, listen: false).username;
    jobsFuture = fetchUserJobs(currentUsername);
  }

  Future<List<Map<String, dynamic>>> fetchUserJobs(
      String currentUsername) async {
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
                })
            .toList();
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
                          ticketNumber: job["ticket_number"],
                          datetime: job["datetime"],
                          customer: job["customer"],
                          handyman: job["handyman"],
                          jobStatus: job["job_status"],
                          paymentStatus: job["payment_status"],
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
                          ticketNumber: job["ticket_number"],
                          datetime: job["datetime"],
                          customer: job["customer"],
                          handyman: job["handyman"],
                          jobStatus: job["job_status"],
                          paymentStatus: job["payment_status"],
                        )),
                const SizedBox(height: 15),
                const Text(
                  "Completed Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...jobs
                    .where((job) => job["job_status"] == "Completed")
                    .map((job) => JobCircles(
                          ticketNumber: job["ticket_number"],
                          datetime: job["datetime"],
                          customer: job["customer"],
                          handyman: job["handyman"],
                          jobStatus: job["job_status"],
                          paymentStatus: job["payment_status"],
                        ))
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
    required this.ticketNumber,
    required this.datetime,
    required this.customer,
    required this.handyman,
    required this.jobStatus,
    required this.paymentStatus,
  });

  final int ticketNumber;
  final String datetime;
  final String customer;
  final String handyman;
  final String jobStatus;
  final String paymentStatus;

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
          if (jobStatus == 'Completed') {
            Navigator.push(
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
            ],
          ),
        ),
      ),
    );
  }
}
