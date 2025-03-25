import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

import 'api_service.dart';
import 'package:provider/provider.dart';
import '/providers/profile_provider.dart';

import 'package:kayakita_sp/editprofile.dart';
import 'package:kayakita_sp/main.dart';
import 'package:kayakita_sp/bookings.dart';
import 'package:kayakita_sp/bookingcontroller.dart';
import 'package:kayakita_sp/joblistings.dart';
import 'package:kayakita_sp/chat.dart';
import 'package:kayakita_sp/payment.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({super.key, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String firstName = "Loading...";
  String workerUsername = "";
  bool _showOverlay = true;
  List<dynamic> reviews = [];
  bool _isLoading = true;
  bool _isSuspended = false;
  String? _suspensionType;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
    Provider.of<BookingController>(context, listen: false)
        .fetchBookings(widget.email);
  }

  Future<void> _checkUserStatus() async {
    try {
      final response = await ApiService.getWorkers();
      final List<dynamic> workers = json.decode(response.body);

      final worker = workers.firstWhere(
        (worker) => worker['email'] == widget.email,
        orElse: () => null,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (worker != null) {
            firstName = worker['first_name'] ?? "Unknown";
            workerUsername = worker['username'] ?? "";
            _isSuspended = worker['is_suspended'] == 'Temporary' ||
                worker['is_suspended'] == 'Permanent';
            _suspensionType = worker['is_suspended'];
          } else {
            firstName = "Email not found";
            workerUsername = "";
          }
        });
      }

      if (workerUsername.isNotEmpty && !_isSuspended) {
        fetchReviews(workerUsername);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          firstName = "Network Error: $e";
          workerUsername = "";
        });
      }
    }
  }

  Future<void> fetchReviews(String username) async {
    try {
      final response = await ApiService.getWorkerReviews(username);
      if (response.statusCode == 200) {
        final List<dynamic> fetchedReviews = json.decode(response.body);
        setState(() {
          reviews = fetchedReviews;
        });
      } else {
        throw Exception("Failed to fetch reviews: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching reviews: $e");
      setState(() {
        reviews = [];
      });
    }
  }

  void _onItemTapped(int index) {
    if (_isSuspended) return;

    setState(() {
      _selectedIndex = index;
      _showOverlay = _selectedIndex == 0;
      if (_selectedIndex == 0 || _selectedIndex == 1) {
        fetchReviews(workerUsername);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isSuspended) {
      return _buildSuspendedScreen();
    }

    return _buildNormalScreen();
  }

  Widget _buildSuspendedScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.block, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                'Account Suspended',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your account has been $_suspensionType suspended.',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Please contact support for more information.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNormalScreen() {
    final List<Widget> _screens = [
      HomePage(
        firstName: firstName,
        onTotalBookingsTap: () {
          if (_isSuspended) return;
          setState(() {
            _selectedIndex = 1;
          });
        },
        reviews: reviews,
      ),
      BookingScreen(),
      JobListingsScreen(),
      PaymentScreen(),
      ChatScreen(),
    ];

    workerUsername = Provider.of<UserProvider>(context, listen: false).username;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _screens[_selectedIndex],
          if (!_isSuspended)
            Consumer<BookingController>(
              builder: (context, controller, child) {
                if (controller.pendingBookingsCount > 0 && _showOverlay) {
                  return Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "You have ${controller.pendingBookingsCount} pending Job Bookings",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon:
                                Icon(Icons.chevron_right, color: Colors.white),
                            onPressed: () => {_onItemTapped(1)},
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF87027B),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Job Listing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}

// HomePage Widget
class HomePage extends StatelessWidget {
  final String firstName;
  final VoidCallback onTotalBookingsTap;
  final List<dynamic> reviews;

  const HomePage({
    super.key,
    required this.firstName,
    required this.onTotalBookingsTap,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        title: const Text("Service Provider"),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            tooltip: 'Profile',
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          )
        ],
      ),
      endDrawer: Drawer(
        key: const Key('homeDrawer'),
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          children: [
            SizedBox(
              height: 88,
              child: DrawerHeader(
                padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
                decoration: const BoxDecoration(),
                child: Row(
                  children: [
                    Image.asset('assets/logofull.png',
                        key: const Key('logo full')),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.account_circle, size: 40),
                      onPressed: () {
                        _scaffoldKey.currentState?.closeEndDrawer();
                      },
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, bottom: 5, top: 10),
                        child: Text(
                          'Account',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SidebarButton(
                      title: 'Edit Profile',
                      icon: Icons.person,
                      screen: EditProfileScreen(),
                    ),
                    const SidebarButton(
                      title: 'Security',
                      icon: Icons.shield,
                      screen: null,
                    ),
                    const SidebarButton(
                      title: 'Notifications',
                      icon: Icons.notifications,
                      screen: null,
                    ),
                    const SidebarButton(
                      title: 'Privacy',
                      icon: Icons.lock,
                      screen: null,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, bottom: 5, top: 10),
                        child: Text(
                          'Support & About',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SidebarButton(
                      title: 'My Subscription',
                      icon: Icons.business_center,
                      screen: null,
                    ),
                    const SidebarButton(
                      title: 'Help & Support',
                      icon: Icons.help,
                      screen: null,
                    ),
                    const SidebarButton(
                      title: 'Terms and Policies',
                      icon: Icons.policy,
                      screen: null,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, bottom: 5, top: 10),
                        child: Text(
                          'Cache & Cellular',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SidebarButton(
                      title: 'Free up space',
                      icon: Icons.delete,
                      screen: null,
                    ),
                    const SidebarButton(
                      title: 'Data Saver',
                      icon: Icons.moving,
                      screen: null,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, bottom: 5, top: 10),
                        child: Text(
                          'Actions',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SidebarButton(
                      title: 'Report a problem',
                      icon: Icons.flag,
                      screen: null,
                    ),
                    const SidebarButton(
                      title: 'Add account',
                      icon: Icons.people,
                      screen: null,
                    ),
                    const SidebarButton(
                      title: 'Log out',
                      icon: Icons.logout,
                      screen: MyApp(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello, $firstName!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Card(
                color: Colors.purple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    children: const [
                      Icon(Icons.account_balance_wallet,
                          color: Colors.white, size: 36),
                      SizedBox(width: 12),
                      Text(
                        "Today's Earnings",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        "₱420.69",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onTotalBookingsTap,
                      child: _buildStatCard("Total Bookings", "46"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatCard("Completed Services", "5")),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: _buildStatCard("Monthly Earnings", "₱19,983.79")),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatCard("Wallet", "₱3078.00")),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Monthly Revenue",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                height: 150,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
                  ],
                ),
                child: LineChart(LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(1, 100),
                        FlSpot(2, 200),
                        FlSpot(3, 150),
                        FlSpot(4, 250),
                        FlSpot(5, 180),
                        FlSpot(6, 300),
                      ],
                      isCurved: true,
                      gradient: LinearGradient(
                          colors: [Colors.purple, Colors.deepPurple]),
                      barWidth: 3,
                      isStrokeCapRound: true,
                    )
                  ],
                )),
              ),
              const SizedBox(height: 16),
              const Text("Reviews about you",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...reviews
                  .map((review) => _buildReview(
                        "assets/reviewprofile.png",
                        review['rating'].toString(),
                        review['review'],
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      color: const Color(0xFF640287),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReview(String imagePath, String rating, String reviewText) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: null),
        title: Text(rating, style: const TextStyle(fontSize: 16)),
        subtitle: Text(reviewText,
            style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ),
    );
  }
}

// SidebarButton Widget (unchanged)
class SidebarButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? screen;

  const SidebarButton({
    Key? key,
    required this.title,
    required this.icon,
    this.screen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen!),
          );
        }
      },
    );
  }
}
