import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kayakita_gov/api_service.dart';
import 'package:kayakita_gov/certifyworker.dart';

class Worker {
  Worker({
    required this.name,
    required this.username,
    required this.servicePreference,
    required this.status, // Default status
  });

  final String name;
  final String username;
  final String servicePreference;
  final String status;

  factory Worker.fromJson(Map<String, dynamic> worker) {
    return Worker(
      name: '${worker['first_name']} ${worker['last_name']}',
      username: worker['username'] ?? '',
      servicePreference: worker['service_preference'],
      status: worker['is_certified']
    );
  }
}

Future<List<Worker>> fetchWorkers() async {
  final response = await ApiService.getWorkers();

  final List<dynamic> data = json.decode(response.body);

  List<Worker> workers = data
    .map((item) => Worker.fromJson(item))
    .where((worker) => worker.servicePreference != 'N/A' 
                    && worker.servicePreference != '')
    .toList();

  return workers;
}

class CertificationScreen extends StatefulWidget {
  const CertificationScreen({super.key});

  @override
  State<CertificationScreen> createState() => _CertificationScreenState();
}

class _CertificationScreenState extends State<CertificationScreen> {
  late Future<List<Worker>> _workersFuture;

  @override
  void initState() {
    super.initState();
    _workersFuture = fetchWorkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text('Certification', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF000E53),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: FutureBuilder<List<Worker>>(
        future: _workersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No workers available."));
          } else {
            final workers = snapshot.data!;
            return ListView.builder(
              itemCount: workers.length,
              itemBuilder: (context, index) {
                return WorkerCard(worker: workers[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class WorkerCard extends StatefulWidget {
  const WorkerCard({super.key, required this.worker});

  final Worker worker;

  @override
  State<WorkerCard> createState() => _WorkerCardState();
}

class _WorkerCardState extends State<WorkerCard> {

  Color _getColor(String status) {
    switch (status) {
      case 'denied':
        return Colors.red;
      case 'accepted':
        return Colors.green;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => 
            CertifyWorkerScreen(workerUsername: widget.worker.username)
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [ 
                  Icon(Icons.account_circle, size: 50),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.worker.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000E53),
                        ),
                      ),

                      Text(
                        widget.worker.servicePreference,
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ]
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.worker.status == 'accepted' ? 'Certified'
                    : widget.worker.status == 'denied' ? 'Denied'
                    : 'Pending',
                    style: TextStyle(
                      fontSize: 16,
                      color: _getColor(widget.worker.status)
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: _getColor(widget.worker.status), // Customize the color
                  ),
                ],
              ),
            ]
          )
        ),
      )
    );
  }
}