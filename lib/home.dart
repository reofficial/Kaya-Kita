import 'package:flutter/material.dart';
import 'package:starter/editprofile.dart';
import 'package:starter/main.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomTextField(hintText: 'Find services near your area' ,),
        backgroundColor: Color(0xFF87027B),
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
        width: 200,
        child: Column(
          children: [
            SizedBox(
              height: 88,
              child:
              DrawerHeader(
                padding: EdgeInsets.only(bottom: 5, left: 10, right: 10),
                decoration: BoxDecoration(),
                child: Row(
                  children: [
                    Image.asset('assets/logofull.png'),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.account_circle, size: 40),
                      onPressed: () {
                        _scaffoldKey.currentState?.closeEndDrawer();
                      },
                    )
                  ]
                )
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left:10, bottom: 5, top: 10) ,
                child: Text(
                  'Account', 
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold 
                  ),
                ),
              ),
            ),
            CustomButton(title: 'Edit Profile', icon: Icons.person, screen: EditProfileScreen()),
            CustomButton(title: 'Security', icon: Icons.shield, screen: null),
            CustomButton(title: 'Notifications', icon: Icons.notifications, screen: null),
            CustomButton(title: 'Privacy', icon: Icons.lock, screen: null),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left:10, bottom: 5, top: 10) ,
                child: Text(
                  'Support & About', 
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold 
                  ),
                ),
              ),
            ),
            CustomButton(title: 'My Subscription', icon: Icons.business_center, screen: null),
            CustomButton(title: 'Help & Support', icon: Icons.help, screen: null),
            CustomButton(title: 'Terms and Policies', icon: Icons.policy, screen: null),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left:10, bottom: 5, top: 10) ,
                child: Text(
                  'Cache & Cellular', 
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold 
                  ),
                ),
              ),
            ),
            CustomButton(title: 'Free up space', icon: Icons.delete, screen: null),
            CustomButton(title: 'Data Saver', icon: Icons.moving, screen: null),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left:10, bottom: 5, top: 10) ,
                child: Text(
                  'Actions', 
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold 
                  ),
                ),
              ),
            ),
            CustomButton(title: 'Report a problem', icon: Icons.flag, screen: null),
            CustomButton(title: 'Add account', icon: Icons.people, screen: null),
            CustomButton(title: 'Log out', icon: Icons.logout, screen: MyApp()),
          ],
        ),
      ),

      body: Center(
        child: Text(
          "(rest of Home Page to follow)",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.hintText, this.borderColor = const Color(0xFFE8F0FE)});

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
      )
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.title, 
                      required this.icon, required this.screen,
                      this.color = const Color.fromARGB(255, 223, 223, 223)});

  final String title;
  final IconData icon;
  final Widget? screen;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: 180,
      child:
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.only(left: 5),
          backgroundColor: const Color.fromARGB(255, 223, 223, 223),
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(1)
          )
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            SizedBox(width: 10),
            Text(
              title, 
              style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),)
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