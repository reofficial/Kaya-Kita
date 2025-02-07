import 'package:flutter/material.dart';
import 'dart:developer';
import 'entrance.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    log("Entered PersonalInfoScreen"); 
    return Scaffold(
      resizeToAvoidBottomInset: false, //finally, i've fixed the 3-hour problem where the keyboard pushes the image up
      appBar: AppBar(
        title: Text('Personal Information', style: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF000000)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: -30, 
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/personalinfo.png', 
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'User Details',
                        style: TextStyle(
                          color: Color(0xFF87027B),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomTextField(hintText: "First Name"),
                      SizedBox(height: 10),
                      CustomTextField(hintText: "Last Name"),
                      SizedBox(height: 10),
                      CustomTextField(hintText: "Mobile Number"),
                      SizedBox(height: 10),
                      CustomTextField(hintText: "Address"),
                      SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF87027B),
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EntranceScreen(), 
                              ),
                            );
                          },
                          child: Text("Submit", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
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
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: borderColor.withAlpha((0.2 * 255).toInt()),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF87027B)),
        ),
      ),
    );
  }
}
