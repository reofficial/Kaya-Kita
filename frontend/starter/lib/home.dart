import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

import 'api_service.dart';
import 'package:provider/provider.dart';
import '/providers/profile_provider.dart';

import 'package:starter/main.dart';
import 'package:starter/jobcategories.dart';
import 'package:starter/editprofile.dart';
import 'package:starter/nearbyworkers.dart';
import 'package:starter/newpost.dart';
import 'package:starter/joblistings.dart';
import 'package:starter/orders.dart';
import 'package:starter/customerjoblistings.dart';
import 'package:starter/chat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _isSuspended = false;
  String? _suspensionType;
  String? _userName;
  Timer? _disputeCheckTimer; 
  List<dynamic> _previousDisputes = [];
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
    _startDisputeCheckTimer(); 
  }

  @override
  void dispose() {
    _disputeCheckTimer?.cancel(); 
    super.dispose();
  }

  void _startDisputeCheckTimer() {
    _checkForResolvedDisputes();
    _disputeCheckTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _checkForResolvedDisputes();
    });
  }

  Future<void> _checkForResolvedDisputes() async {
  try {
    final username = Provider.of<UserProvider>(context, listen: false).username;
    final response = await ApiService.getDisputes();
    
    if (response.statusCode == 200) {
      List<dynamic> currentDisputes = json.decode(response.body);
      
      var resolvedDisputes = currentDisputes.where((dispute) => 
        (dispute['customer_username'] == username || dispute['worker_username'] == username) && 
        dispute['dispute_status'] == 'Resolved'
      ).toList();
      
      for (var dispute in resolvedDisputes) {
        bool wasPreviouslyResolved = _previousDisputes.any((prev) => 
          prev['dispute_id'] == dispute['dispute_id'] && 
          prev['dispute_status'] == 'Resolved'
        );
        
        if (!wasPreviouslyResolved && mounted) {
          _showResolvedNotification(dispute);
        }
      }

      if (mounted) {
        setState(() {
          _previousDisputes = currentDisputes;
        });
      }
    }
  } catch (e) {
    debugPrint('Error checking disputes: $e');
  }
}

  void _showResolvedNotification(Map<String, dynamic> dispute) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dispute Resolved!\nTicket #${dispute['ticket_number']} has been resolved.'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }


  Future<void> _checkUserStatus() async {
    try {
      final username =
          Provider.of<UserProvider>(context, listen: false).username;

      final response = await ApiService.getCustomers();
      List<dynamic> customers = json.decode(response.body);

      final customer = customers.firstWhere(
        (c) => c['username'] == username,
        orElse: () => {},
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (customer.isNotEmpty) {
            _userName = customer['name'] ?? 'User'; // Adjust field name
            _isSuspended = customer['is_suspended'] == 'Temporary' ||
                customer['is_suspended'] == 'Permanent';
            _suspensionType = customer['is_suspended'];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('Error checking user status: $e');
    }
  }

  void _onItemTapped(int index) {
    if (_isSuspended) return;

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const CustomerJobListingScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewPostScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OrdersScreen()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const CustomTextField(
          hintText: 'Find services near your area',
        ),
        backgroundColor: const Color(0xFF87027B),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle,
                size: 40, color: Color(0xFFE8F0FE)),
            tooltip: 'Profile',
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
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
                    SidebarButton(
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
            icon: Icon(Icons.work),
            label: 'Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Wallet",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Php 3,082.18",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildExploreItem("Biker", Icons.motorcycle),
                      _buildExploreItem("Driver", Icons.directions_car),
                      _buildExploreItem("PasaBuy", Icons.food_bank),
                      _buildExploreItem("Pabili", Icons.shopping_cart),
                      _buildExploreItem("Laundry", Icons.local_laundry_service),
                      _buildExploreItem("More", Icons.more_horiz),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 0),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/promos.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 10),
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Submit entry",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _isSuspended
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const JobListingsScreen(),
                        ),
                      );
                    },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFD81B60).withOpacity(0.9),
                      const Color(0xFF87027B).withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Discover Job Listings",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Find catering, transport, and more",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreItem(String title, IconData icon) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: _isSuspended
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => title == 'More'
                              ? const JobCategoriesScreen()
                              : NearbyWorkersScreen(jobName: title)),
                    );
                  },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(10),
              minimumSize: const Size(40, 40),
            ),
            child: Icon(icon, size: 40, color: Colors.grey[700])),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.borderColor = const Color(0xFFE8F0FE),
  });

  final String hintText;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 37,
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 12.0,
            fontFamily: 'Roboto',
            color: Colors.black87.withAlpha(95),
          ),
          filled: true,
          fillColor: borderColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(color: Color(0xFF87027B)),
          ),
        ),
      ),
    );
  }
}

class SidebarButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? screen;
  final VoidCallback? onTap;

  const SidebarButton({
    Key? key,
    required this.title,
    required this.icon,
    this.screen,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop();
        if (onTap != null) {
          onTap!();
        } else if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen!),
          );
        }
      },
    );
  }
}


