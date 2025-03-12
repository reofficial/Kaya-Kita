import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kayakita_sp/editprofile.dart';
import 'package:kayakita_sp/main.dart';
import 'bookings.dart';
import 'api_service.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({super.key, required this.email});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; 
  String firstName = "Loading..."; 

  @override
  void initState() {
    super.initState();
    fetchFirstName(widget.email);
  }

  Future<void> fetchFirstName(String email) async {
  try {
    final response = await ApiService.getWorkers();
    final List<dynamic> workers = json.decode(response.body);
    
    final worker = workers.firstWhere(
      (worker) => worker['email'] == email,
      orElse: () => null, 
    );

    setState(() {
      firstName = worker != null ? worker['first_name'] ?? "Unknown" : "Email not found";
    });
  } catch (e) {
    setState(() {
      firstName = "Network Error: $e";
    });
  }
}


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomePage(firstName: firstName),
      BookingScreen(),
      PaymentsPage(),
      ChatsPage(),
    ];
    
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text("Service Provider"),
      //   backgroundColor: Colors.purple,
      // ),
      body: _screens[_selectedIndex], 

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

// pages navigation
class HomePage extends StatelessWidget {
  final String firstName;

  const HomePage({super.key, required this.firstName});
  

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
                      screen: EditProfileScreen(), // PALITAN
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

      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello, $firstName!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Card(
                color: Colors.purple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16), 
                  child: Row(
                    children: const [
                      Icon(Icons.account_balance_wallet, color: Colors.white, size: 36), 
                      SizedBox(width: 12),
                      Text(
                        "Today's Earnings",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), 
                      ),
                      Spacer(),
                      Text(
                        "₱420.69",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), 
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BookingScreen()),
                        );
                      },
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
                  Expanded(child: _buildStatCard("Monthly Earnings", "₱19,983.79")),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatCard("Wallet", "₱3078.00")),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Monthly Revenue", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                height: 150,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
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
                      gradient: LinearGradient(colors: [Colors.purple, Colors.deepPurple]),
                      barWidth: 3,
                      isStrokeCapRound: true,
                    )
                  ],
                )),
              ),
              const SizedBox(height: 16),
              const Text("Reviews about you", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildReview("assets/reviewprofile.png", "⭐⭐⭐⭐⭐", "2nd time booking, maayos po pala gawa niya."),
              _buildReview("assets/reviewprofile.png", "⭐⭐", "Hindi ko po nagustuhan gawa niya..."),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: Colors.purple,
      //   unselectedItemColor: Colors.grey,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Bookings"),
      //     BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Payments"),
      //     BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
      //   ],
      // ),
    );
  }

  Widget _buildStatCard(String title, String value) {
  return Card(
    color: Color(0xFF640287), 
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), 
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
        leading: CircleAvatar(backgroundImage: AssetImage(imagePath)),
        title: Text(rating, style: const TextStyle(fontSize: 16)),
        subtitle: Text(reviewText, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ),
    );
  }
}


// class BookingsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text("Bookings Page"));
//   }
// }

class PaymentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Payments Page"));
  }
}

class ChatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Chats Page"));
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

