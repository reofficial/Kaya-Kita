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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomTextField(
          hintText: 'Find services near your area',
        ),
        backgroundColor: Color(0xFF87027B),
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomBarButton(icon: Icons.home, label: 'Home', onPressed: () {}),
            BottomBarButton(
                icon: Icons.discount, label: 'Promos', onPressed: () {}),
            IconButton(
                icon:
                    Icon(Icons.add_circle, size: 50, color: Color(0xFF87027B)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewPostScreen()),
                  );
                }),
            BottomBarButton(
                icon: Icons.list_alt, label: 'Orders', onPressed: () {}),
            BottomBarButton(icon: Icons.chat, label: 'Chat', onPressed: () {}),
          ],
        ),
      ),
      endDrawer: Drawer(
        key: Key('homeDrawer'),
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          children: [
            SizedBox(
              height: 88,
              child: DrawerHeader(
                  padding: EdgeInsets.only(bottom: 5, left: 10, right: 10),
                  decoration: BoxDecoration(),
                  child: Row(children: [
                    Image.asset('assets/logofull.png', key: Key('logo full')),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.account_circle, size: 40),
                      onPressed: () {
                        _scaffoldKey.currentState?.closeEndDrawer();
                      },
                    )
                  ])),
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 5, top: 10),
                  child: Text(
                    'Account',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SidebarButton(
                  title: 'Edit Profile',
                  icon: Icons.person,
                  screen: EditProfileScreen()),
              SidebarButton(
                  title: 'Security', icon: Icons.shield, screen: null),
              SidebarButton(
                  title: 'Notifications',
                  icon: Icons.notifications,
                  screen: null),
              SidebarButton(title: 'Privacy', icon: Icons.lock, screen: null),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 5, top: 10),
                  child: Text(
                    'Support & About',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SidebarButton(
                  title: 'My Subscription',
                  icon: Icons.business_center,
                  screen: null),
              SidebarButton(
                  title: 'Help & Support', icon: Icons.help, screen: null),
              SidebarButton(
                  title: 'Terms and Policies',
                  icon: Icons.policy,
                  screen: null),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 5, top: 10),
                  child: Text(
                    'Cache & Cellular',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SidebarButton(
                  title: 'Free up space', icon: Icons.delete, screen: null),
              SidebarButton(
                  title: 'Data Saver', icon: Icons.moving, screen: null),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 5, top: 10),
                  child: Text(
                    'Actions',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SidebarButton(
                  title: 'Report a problem', icon: Icons.flag, screen: null),
              SidebarButton(
                  title: 'Add account', icon: Icons.people, screen: null),
              SidebarButton(
                  title: 'Log out', icon: Icons.logout, screen: MyApp()),
            ])))
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // TODO: replace text with actual home layout
            Text("[WALLET INFO]"),
            Text("[JOB SQUARES]"),
            Text("[PROMOS]"),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const JobListingsScreen()),
                );
              },
              child: Text('Discover Job Listings     >'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hintText,
      this.borderColor = const Color(0xFFE8F0FE)});

  final String hintText;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 37,
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
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
              borderSide: BorderSide(color: Color(0xFF87027B)),
            ),
          ),
        ));
  }
}

class SidebarButton extends StatelessWidget {
  const SidebarButton(
      {super.key,
      required this.title,
      required this.icon,
      required this.screen,
      this.color = const Color.fromARGB(255, 223, 223, 223)});

  final String title;
  final IconData icon;
  final Widget? screen;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: MediaQuery.of(context).size.width * 0.45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: 5),
            backgroundColor: const Color.fromARGB(255, 223, 223, 223),
            shape:
                BeveledRectangleBorder(borderRadius: BorderRadius.circular(1))),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        onPressed: () {
          if (screen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => screen!,
              ),
            );
          }
        },
      ),
    );
  }
}

class BottomBarButton extends StatelessWidget {
  const BottomBarButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed});

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey, size: 30),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
