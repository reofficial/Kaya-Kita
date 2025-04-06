import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'api_service.dart';
import 'userprofile.dart';

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
      name: '${worker['first_name'] ?? ''} ${worker['last_name'] ?? ''}',
      username: worker['username'] ?? '',
      servicePreference: worker['service_preference'] ?? '',
      isCertified: worker['is_certified'] ?? '',
      isSuspended: worker['is_suspended'] ?? 'No',
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
      name: '${customer['first_name'] ?? ''} ${customer['last_name'] ?? ''}',
      username: customer['username'] ?? '',
      address: customer['address'] ?? '',
      isSuspended: customer['is_suspended'] ?? 'No',
    );
  }
}

Future<List<Worker>> fetchWorkers() async {
  try {
    final response = await ApiService.getWorkers();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) ?? [];
      return data.map((item) => Worker.fromJson(item ?? {})).toList();
    } else {
      throw Exception('Failed to load workers: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching workers: $e');
  }
}

Future<List<Customer>> fetchCustomers() async {
  try {
    final response = await ApiService.getCustomers();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) ?? [];
      return data.map((item) => Customer.fromJson(item ?? {})).toList();
    } else {
      throw Exception('Failed to load customers: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching customers: $e');
  }
}

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  late Future<List<Worker>> _workersFuture;
  late Future<List<Customer>> _customersFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() {
    setState(() {
      _workersFuture = fetchWorkers();
      _customersFuture = fetchCustomers();
    });
    return Future.value();
  }

  Future<void> _updateSuspension(String username, bool isWorker, String status) async {
    try {
      final response = await ApiService.updateUserSuspension(username, status, isWorker);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated suspension status to "$status"')),
        );
        _refreshData();
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _showBanOptionsDialog(String username, bool isWorker, String currentStatus) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Manage Suspension"),
        content: const Text("Choose an action:"),
        actions: [
          if (currentStatus == 'Temporary' || currentStatus == 'Permanent')
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateSuspension(username, isWorker, 'No');
              },
              child: const Text("Reinstate"),
            ),
          if (currentStatus == 'Temporary')
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateSuspension(username, isWorker, 'Permanent');
              },
              child: const Text("Make Permanent"),
            ),
          if (currentStatus == 'No')
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateSuspension(username, isWorker, 'Temporary');
              },
              child: const Text("Temporary Ban"),
            ),
          if (currentStatus == 'No')
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateSuspension(username, isWorker, 'Permanent');
              },
              child: const Text("Permanent Ban"),
            ),
        ],
      ),
    );
  }

  Widget _buildWorkerCard(Worker worker) {
    return WorkerCard(
      worker: worker,
      onTapManage: () => _showBanOptionsDialog(worker.username, true, worker.isSuspended),
    );
  }

  Widget _buildCustomerCard(Customer customer) {
    return CustomerCard(
      customer: customer,
      onTapManage: () => _showBanOptionsDialog(customer.username, false, customer.isSuspended),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: const Text('Manage Users', style: TextStyle(color: Colors.white)),
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
                    return const Center(child: Text("No workers available"));
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) =>
                          _buildWorkerCard(snapshot.data![index]),
                    );
                  }
                },
              ),
            ),
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
                    return const Center(child: Text("No customers available"));
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) =>
                          _buildCustomerCard(snapshot.data![index]),
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

class WorkerCard extends StatelessWidget {
  final Worker worker;
  final VoidCallback onTapManage;

  const WorkerCard({
    super.key,
    required this.worker,
    required this.onTapManage,
  });

  @override
  Widget build(BuildContext context) {
    return _UserCard(
      icon: Icons.handyman,
      name: worker.name,
      subtitle: worker.servicePreference,
      status: worker.isSuspended,
      extra: 'Certification: ${worker.isCertified}',
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileScreen(
            username: worker.username,
            isWorker: true,
          ),
        ),
      ),
      onTapManage: onTapManage,
    );
  }
}

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTapManage;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.onTapManage,
  });

  @override
  Widget build(BuildContext context) {
    return _UserCard(
      icon: Icons.person,
      name: customer.name,
      subtitle: customer.address,
      status: customer.isSuspended,
      extra: null,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileScreen(
            username: customer.username,
            isWorker: false,
          ),
        ),
      ),
      onTapManage: onTapManage,
    );
  }
}

class _UserCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String subtitle;
  final String status;
  final String? extra;
  final VoidCallback onTap;
  final VoidCallback onTapManage;

  const _UserCard({
    required this.icon,
    required this.name,
    required this.subtitle,
    required this.status,
    required this.extra,
    required this.onTap,
    required this.onTapManage,
  });

  Color _getStatusColor(String status) {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(icon, size: 50, color: const Color(0xFF000E53)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000E53),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 62),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (extra != null)
                      Text(
                        extra!,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: $status',
                      style: TextStyle(
                        fontSize: 14,
                        color: _getStatusColor(status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: onTapManage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Manage Suspension"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
