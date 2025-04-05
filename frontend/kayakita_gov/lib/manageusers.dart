import 'package:flutter/material.dart';
import 'dart:async';
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
    this.suspensionEndTime,
  });

  final String name;
  final String username;
  final String servicePreference;
  final String isCertified;
  final String isSuspended;
  final DateTime? suspensionEndTime;

  factory Worker.fromJson(Map<String, dynamic> worker) {
    return Worker(
      name: '${worker['first_name']} ${worker['last_name']}',
      username: worker['username'] ?? '',
      servicePreference: worker['service_preference'] ?? '',
      isCertified: worker['is_certified'],
      isSuspended: worker['is_suspended'],
      suspensionEndTime: worker['suspension_end_time'] != null 
          ? DateTime.parse(worker['suspension_end_time']) 
          : null,
    );
  }
}

class Customer {
  Customer({
    required this.name,
    required this.username,
    required this.address,
    required this.isSuspended,
    this.suspensionEndTime,
  });

  final String name;
  final String username;
  final String address;
  final String isSuspended;
  final DateTime? suspensionEndTime;

  factory Customer.fromJson(Map<String, dynamic> customer) {
    return Customer(
      name: '${customer['first_name']} ${customer['last_name']}',
      username: customer['username'] ?? '',
      address: customer['address'] ?? '',
      isSuspended: customer['is_suspended'],
      suspensionEndTime: customer['suspension_end_time'] != null 
          ? DateTime.parse(customer['suspension_end_time']) 
          : null,
    );
  }
}

Future<List<Worker>> fetchWorkers() async {
  try {
    final response = await ApiService.getWorkers();
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Worker.fromJson(item)).toList();
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
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Customer.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load customers: ${response.statusCode}');
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
                        const Icon(Icons.handyman, size: 50, color: Color(0xFF000E53)),
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
                  const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
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
                      ),
                      const SizedBox(height: 4),
                      _buildSuspensionStatus(worker),
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

  Widget _buildSuspensionStatus(Worker worker) {
    if (worker.isSuspended == 'Temporary' && worker.suspensionEndTime != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temporary suspension',
            style: TextStyle(
              fontSize: 14,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          CountdownTimer(endTime: worker.suspensionEndTime!),
        ],
      );
    } else {
      return Text(
        '${worker.isSuspended} suspension',
        style: TextStyle(
          fontSize: 14,
          color: _getSuspensionColor(worker.isSuspended),
          fontWeight: FontWeight.bold,
        ),
      );
    }
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

class CustomerCard extends StatefulWidget {
  const CustomerCard({super.key, required this.customer, required this.onStatusChanged});

  final Customer customer;
  final Function() onStatusChanged;

  @override
  State<CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  Duration? _selectedDuration;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(
              username: widget.customer.username,
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
                        const Icon(Icons.person, size: 50, color: Color(0xFF000E53)),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.customer.name,
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
                                widget.customer.address,
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
                  const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
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
                      _buildSuspensionStatus(),
                      const SizedBox(height: 8),
                      if (widget.customer.isSuspended != 'Permanent')
                        Row(
                          children: [
                            if (widget.customer.isSuspended == 'Temporary')
                              ElevatedButton(
                                onPressed: () => _changeStatus('No'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Reinstate Now'),
                              ),
                            if (widget.customer.isSuspended == 'Temporary')
                              const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _showBanOptions,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Ban Options'),
                            ),
                          ],
                        ),
                      if (widget.customer.isSuspended == 'Permanent')
                        ElevatedButton(
                          onPressed: () => _changeStatus('No'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Reinstate User'),
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

  Widget _buildSuspensionStatus() {
    if (widget.customer.isSuspended == 'Temporary' && widget.customer.suspensionEndTime != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temporary suspension',
            style: TextStyle(
              fontSize: 14,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          CountdownTimer(endTime: widget.customer.suspensionEndTime!),
        ],
      );
    } else {
      return Text(
        '${widget.customer.isSuspended} suspension',
        style: TextStyle(
          fontSize: 14,
          color: _getSuspensionColor(widget.customer.isSuspended),
          fontWeight: FontWeight.bold,
        ),
      );
    }
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

  void _showBanOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Ban Duration',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  RadioListTile<Duration>(
                    title: const Text('1 Hour'),
                    value: const Duration(hours: 1),
                    groupValue: _selectedDuration,
                    onChanged: (Duration? value) => setModalState(() => _selectedDuration = value),
                  ),
                  RadioListTile<Duration>(
                    title: const Text('1 Day'),
                    value: const Duration(days: 1),
                    groupValue: _selectedDuration,
                    onChanged: (Duration? value) => setModalState(() => _selectedDuration = value),
                  ),
                  RadioListTile<Duration>(
                    title: const Text('1 Week'),
                    value: const Duration(days: 7),
                    groupValue: _selectedDuration,
                    onChanged: (Duration? value) => setModalState(() => _selectedDuration = value),
                  ),
                  RadioListTile<Duration>(
                    title: const Text('1 Month'),
                    value: const Duration(days: 30),
                    groupValue: _selectedDuration,
                    onChanged: (Duration? value) => setModalState(() => _selectedDuration = value),
                  ),
                  const Divider(),
                  RadioListTile<Duration?>(
                    title: const Text('Permanent Ban'),
                    value: null,
                    groupValue: _selectedDuration,
                    onChanged: (Duration? value) => setModalState(() => _selectedDuration = value),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedDuration != null) {
                            _tempBanUser(_selectedDuration!);
                          } else {
                            _changeStatus('Permanent');
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _tempBanUser(Duration duration) async {
    final endTime = DateTime.now().add(duration);
    try {
      final response = await ApiService.updateUserSuspension(
        widget.customer.username,
        'Temporary',
        endTime.toIso8601String() as bool,
      );
      
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User temporarily banned until ${endTime.toString()}'),
            backgroundColor: Colors.black87,
          ),
        );
        widget.onStatusChanged();
      } else {
        throw Exception('Failed to update user status');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _changeStatus(String newStatus) async {
    try {
      final response = await ApiService.updateUserSuspension(
        widget.customer.username,
        newStatus,
        false,
      );
      
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus == 'No'
                  ? 'User has been reinstated.'
                  : 'User has been permanently banned.',
            ),
            backgroundColor: Colors.black87,
          ),
        );
        widget.onStatusChanged();
      } else {
        throw Exception('Failed to update user status');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class CountdownTimer extends StatefulWidget {
  final DateTime endTime;

  const CountdownTimer({super.key, required this.endTime});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(_calculateRemaining);
      }
    });
  }

  void _calculateRemaining() {
    final now = DateTime.now();
    if (now.isAfter(widget.endTime)) {
      _remaining = Duration.zero;
      _timer.cancel();
    } else {
      _remaining = widget.endTime.difference(now);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Time remaining: ${_formatDuration(_remaining)}',
      style: const TextStyle(fontSize: 13, color: Colors.orange),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inDays > 0) {
      return "${duration.inDays}d ${hours}h ${minutes}m";
    } else if (duration.inHours > 0) {
      return "${hours}h ${minutes}m ${seconds}s";
    } else if (duration.inMinutes > 0) {
      return "${minutes}m ${seconds}s";
    } else {
      return "${seconds}s";
    }
  }
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
                      itemBuilder: (context, index) {
                        return WorkerCard(worker: snapshot.data![index]);
                      },
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
                      itemBuilder: (context, index) {
                        return CustomerCard(
                          customer: snapshot.data![index],
                          onStatusChanged: _refreshData,
                        );
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