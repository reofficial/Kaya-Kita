import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:starter/api_service.dart';
import 'package:starter/incomingworker.dart';

import 'package:provider/provider.dart';
import 'package:starter/providers/profile_provider.dart';
import 'package:intl/intl.dart';

class NearbyWorkersScreen extends StatefulWidget {
  const NearbyWorkersScreen({
    super.key,
    required this.jobName,
  });

  final String jobName;

  @override
  State<NearbyWorkersScreen> createState() => _NearbyWorkersScreenState();
}

class _NearbyWorkersScreenState extends State<NearbyWorkersScreen> {
  bool isTabOpen = false;

  late String username;

  final DraggableScrollableController _controller =
      DraggableScrollableController();

  late Future<List<Map<String, dynamic>>> workersFuture;
  List<Map<String, dynamic>> workers = [];
  Map<String, dynamic>? selectedWorker;
  int? selectedWorkerIndex;

  String selectedPayment = 'Cash';

  final Duration apiTimeoutDuration = Duration(seconds: 5);

  Future<List<Map<String, dynamic>>> fetchWorkers() async {
    try {
      final response =
          await ApiService.getWorkers().timeout(apiTimeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .where((item) =>
                item['is_certified'] == "accepted" &&
                (item['service_preference'] == widget.jobName ||
                    item['service_preference'] == 'N/A' ||
                    item['service_preference'] == ''))
            .map((item) => {
                  'name':
                      (item['first_name'] != null && item['last_name'] != null)
                          ? '${item['first_name']} ${item['last_name']}'
                          : null,
                  'rating': 5.0,
                  'username': item['username'],
                  'service_preference': item['service_preference'] ?? "N/A"
                })
            .toList();
      } else {
        throw Exception(
            'Failed to load workers (Status: ${response.statusCode})');
      }
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching workers: Request timed out.'),
          backgroundColor: Colors.red,
        ),
      );
      throw Exception(TimeoutException);
    } catch (e) {
      throw Exception('Error fetching workers: $e');
    }
  }

  Future<void> handleJobBooking(
      Map<String, dynamic>? worker, String username) async {
    if (selectedPayment == 'E-Cash') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please set up your E-Cash payment to continue.'),
          backgroundColor: Colors.red.shade900,
        ),
      );
      return;
    }

    try {
      String formattedDateTime =
          DateFormat("d MMM. yyyy - h:mm a").format(DateTime.now());

      Map<String, dynamic> jobCircle = {
        "ticket_number": 0, // need help with this
        "datetime": formattedDateTime,
        "customer": username,
        "handyman": worker?['username'] ?? "Unknown",
        "job_status": "Pending",
        "payment_status": "Not Paid"
      };

      // Add timeout to the API call
      final response =
          await ApiService.postJobCircle(jobCircle).timeout(apiTimeoutDuration);

      if (response.statusCode == 201) {
        Future.microtask(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => IncomingWorkerScreen(worker: worker)),
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job booked successfully.')),
        );
      } else {
        throw Exception('Failed to book job (Status: ${response.statusCode})');
      }
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book job: Request timed out.'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book job: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPaymentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(FontAwesomeIcons.moneyBill),
              title: Text('Cash'),
              onTap: () {
                setState(() => selectedPayment = 'Cash');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('E-Cash'),
              onTap: () {
                setState(() => selectedPayment = 'E-Cash');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    workersFuture = fetchWorkers().then((loadedWorkers) {
      setState(() {
        workers = loadedWorkers;
      });
      return loadedWorkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    username = Provider.of<UserProvider>(context, listen: false).username;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.jobName,
          style:
              TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF000000)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 180,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // MODE OF PAYMENT
                ElevatedButton(
                  onPressed: _showPaymentOptions,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    minimumSize: Size(0, 36),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(selectedPayment == 'Cash'
                          ? FontAwesomeIcons.moneyBill
                          : Icons.account_balance_wallet),
                      SizedBox(width: 10),
                      Text(selectedPayment,
                          style: TextStyle(
                              color: Color(0xFF000000), fontSize: 14)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),

                Row(
                  children: [
                    // VOUCHERS BUTTON
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        minimumSize: Size(0, 36),
                      ),
                      child: Text(
                        'Vouchers',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF000000)),
                      ),
                    ),

                    SizedBox(width: 10),

                    // GRID BUTTON
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.grid_view_sharp, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ),
                  ],
                )
              ],
            ),

            // 20% OFF VOUCHER BUTTON
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: Container(
                    height: 50, // Fixed height for the button
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // Rounded edges
                    ),
                    child: Row(
                      children: [
                        // Left Side: Light Blue
                        Expanded(
                          flex: 85, // Takes more space for longer text
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              backgroundColor: Colors.lightBlue.shade400,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                            ),
                            child: Text(
                              'Up to 20% off voucher if your worker is late.',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),

                        // Right Side: Dark Blue
                        Expanded(
                          flex: 15, // Smaller space for "Try"
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              backgroundColor: Colors.blue.shade700,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                            ),
                            child: Text(
                              'Try',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),

            SizedBox(height: 2),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SCHEDULE BUTTON
                InkWell(
                  onTap: () {
                    // Add your action here
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFF87027B), width: 2),
                      color: Colors.transparent, // No background color
                    ),
                    child: Icon(
                      Icons.calendar_month,
                      color: Colors.purple,
                      size: 30,
                    ),
                  ),
                ),

                SizedBox(
                  width: 10,
                ),

                // ACCEPT BUTTON
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: selectedWorker != null
                          ? () {
                              handleJobBooking(selectedWorker, username);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF87027B),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey,
                        disabledForegroundColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Accept',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Text('P100/hr',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10)
          ],
        ),
      ),
      body: Stack(children: [
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/map.png',
              height: MediaQuery.of(context).size.height * 0.7,
            ),
          ),
        ),
        DraggableScrollableSheet(
          controller: _controller,
          initialChildSize: 0.4,
          minChildSize: 0.04,
          maxChildSize: 0.4,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Column(
                children: [
                  Grabber(
                    isOnDesktopAndWeb: false,
                    onVerticalDragUpdate: (DragUpdateDetails details) {
                      _controller.animateTo(
                        (_controller.size - details.primaryDelta!)
                            .clamp(0.04, 0.4), // Keep within bounds
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: workersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No workers found.'));
                        } else {
                          return ListView.builder(
                            controller: scrollController,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return _buildWorker(snapshot.data![index],
                                  index == snapshot.data!.length - 1, index);
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ]),
    );
  }

  Widget _buildWorker(Map<String, dynamic> worker, bool isLast, int index) {
    bool isSelected = selectedWorkerIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedWorkerIndex == index) {
            selectedWorkerIndex = -1;
            selectedWorker = null;
          } else {
            selectedWorkerIndex = index;
            selectedWorker =
                worker; // Stores selected worker for screen after accepting
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
            bottom: isLast
                ? BorderSide(color: Colors.grey.shade300, width: 1)
                : BorderSide.none,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: worker['image'] != null
                  ? NetworkImage(worker['image'])
                  : null,
              child: worker['image'] == null
                  ? Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(worker['name'] ?? 'Unknown',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text(
                          worker['name'] == 'Random Assignment'
                              ? 'A worker will be assigned randomly.'
                              : '10-12 mins',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[700])),
                      SizedBox(width: 10),
                      if (worker['name'] != 'Random Assignment') ...[
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        Text(worker['rating']?.toString() ?? 'N/A',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700])),
                      ],
                    ],
                  )
                ],
              ),
            ),
            Text('P 100/hr', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class Grabber extends StatelessWidget {
  const Grabber(
      {super.key,
      required this.onVerticalDragUpdate,
      required this.isOnDesktopAndWeb});

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: Container(
        height: 10,
        width: 200,
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
