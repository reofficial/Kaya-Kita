import 'package:flutter/material.dart';
import 'package:starter/editprofile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomTextField(hintText: 'Find services near your area' ,),
        backgroundColor: Color(0xFF87027B),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle, size: 40, color: Color(0xFFE8F0FE)),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(),
                ),
              );
            },
          ),
          
        ],
      ),

      body: Center(
        child: Text(
          "gagawin ko pa :P",
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