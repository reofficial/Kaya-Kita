import 'package:flutter/material.dart';
import 'dart:convert';
import 'api_service.dart';
import 'userprofile.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class Worker {
  Worker({
    required this.name,
    required this.username,
    required this.servicePreference,
    required this.isCertified,
    required this.isSuspended,
  });

  final String name;
  final String username;
  final String servicePreference;
  final String isCertified;
  final String isSuspended;

  factory Worker.fromJson(Map<String, dynamic> worker) {
    return Worker(
      name: '${worker['first_name']} ${worker['last_name']}',
      username: worker['username'] ?? '',
      servicePreference: worker['service_preference'] ?? '',
      isCertified: worker['is_certified'],
      isSuspended: worker['is_suspended'],
    );
  }
}

class Customer {
  Customer({
    required this.name,
    required this.username,
    required this.address,
    required this.isSuspended,
  });

  final String name;
  final String username;
  final String address;
  final String isSuspended;

  factory Customer.fromJson(Map<String, dynamic> customer) {
    return Customer(
      name: '${customer['first_name']} ${customer['last_name']}',
      username: customer['username'] ?? '',
      address: customer['address'] ?? '',
      isSuspended: customer['is_suspended'],
    );
  }
}

Future<List<Worker>> fetchWorkers() async {
  try {
    final response = await ApiService.getWorkers();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Worker> workers = data.map((item) => Worker.fromJson(item)).toList();
      return workers;
    } else {
      throw Exception('${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching workers: $e');
  }
}

Future<List<Customer>> fetchCustomers() async {
  try {
    final response = await ApiService.getCustomers();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Customer> customers =
          data.map((item) => Customer.fromJson(item)).toList();
      return customers;
    } else {
      throw Exception('${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching customers: $e');
  }
}

class WorkerCard extends StatelessWidget {
  const WorkerCard({super.key, required this.worker});

  final Worker worker;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(
              username: worker.username,
              isWorker: true,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        const Icon(Icons.handyman,
                            size: 50, color: Color(0xFF000E53)),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                worker.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF000E53),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                worker.servicePreference,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 62),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Certification: ${worker.isCertified}',
                        style: TextStyle(
                          fontSize: 14,
                          color: worker.isCertified == 'certified'
                              ? Colors.green
                              : worker.isCertified == 'denied'
                                  ? Colors.red
                                  : Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${worker.isSuspended} suspension',
                        style: TextStyle(
                          fontSize: 14,
                          color: _getSuspensionColor(worker.isSuspended),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSuspensionColor(String status) {
    switch (status) {
      case 'No':
        return Colors.green;
      case 'Temporary':
        return Colors.orange;
      case 'Permanent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class CustomerCard extends StatelessWidget {
  const CustomerCard({super.key, required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(
              username: customer.username,
              isWorker: false,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        const Icon(Icons.person,
                            size: 50, color: Color(0xFF000E53)),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF000E53),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                customer.address,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 62),
                  child: Text(
                    '${customer.isSuspended} suspension',
                    style: TextStyle(
                      fontSize: 14,
                      color: _getSuspensionColor(customer.isSuspended),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSuspensionColor(String status) {
    switch (status) {
      case 'No':
        return Colors.green;
      case 'Temporary':
        return Colors.orange;
      case 'Permanent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  late Future<List<Worker>> _workersFuture;
  late Future<List<Customer>> _customersFuture;

  @override
  void initState() {
    super.initState();
    _workersFuture = fetchWorkers();
    _customersFuture = fetchCustomers();
  }

  Future<void> _refreshData() async {
    setState(() {
      _workersFuture = fetchWorkers();
      _customersFuture = fetchCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title:
              const Text('Manage Users', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF000E53),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.6),
            tabs: const [
              Tab(text: 'Workers', icon: Icon(Icons.handyman)),
              Tab(text: 'Customers', icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Workers Tab
            RefreshIndicator(
              onRefresh: _refreshData,
              child: FutureBuilder<List<Worker>>(
                future: _workersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No workers available",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return WorkerCard(worker: snapshot.data![index]);
                      },
                    );
                  }
                },
              ),
            ),
            // Customers Tab
            RefreshIndicator(
              onRefresh: _refreshData,
              child: FutureBuilder<List<Customer>>(
                future: _customersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No customers available",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return CustomerCard(customer: snapshot.data![index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
