import 'package:flutter/material.dart';
import 'package:starter/main.dart';
import 'package:starter/editprofile.dart';
import 'package:starter/newpost.dart';
import 'package:starter/joblistings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0; // Track the selected index

  // Handle bottom navigation bar item taps
  void _onItemTapped(int index) {
  if (index == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewPostScreen()),
    );
  } else {
    setState(() {
      _selectedIndex = index;
    });
  }
}

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.account_circle, size: 40, color: Color(0xFFE8F0FE)),
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
                    Image.asset('assets/logofull.png', key: const Key('logo full')),
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
                        padding: const EdgeInsets.only(left: 10, bottom: 5, top: 10),
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
                        padding: const EdgeInsets.only(left: 10, bottom: 5, top: 10),
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
                        padding: const EdgeInsets.only(left: 10, bottom: 5, top: 10),
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
                        padding: const EdgeInsets.only(left: 10, bottom: 5, top: 10),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Highlight the active tab
        onTap: _onItemTapped, // Handle tab changes
        selectedItemColor: const Color(0xFF87027B), // Color for the active tab
        unselectedItemColor: Colors.grey, // Color for inactive tabs
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.discount),
            label: 'Promos',
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
            // Top Section (Wallet, etc.)
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  // Wallet Section
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
                  const SizedBox(height: 10),
                  // Explore Section
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildExploreItem("Rider", Icons.motorcycle),
                      _buildExploreItem("Driver", Icons.directions_car),
                      _buildExploreItem("PasaBuy", Icons.food_bank),
                      _buildExploreItem("Pabili", Icons.shopping_cart),
                      _buildExploreItem("Laundry", Icons.local_laundry_service),
                      _buildExploreItem("More", Icons.more_horiz),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Promos Section
                  Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 0),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // Image
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
                            onPressed: () {
                              // Handle submit entry
                            },
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
            // Job Listings Section 
            GestureDetector(
              onTap: () {
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
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
        Icon(icon, size: 40, color: Colors.grey[700]),
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
        // Close the drawer first
        Navigator.of(context).pop();
        // Navigate to the provided screen if it exists
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
