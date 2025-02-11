import 'package:flutter/material.dart';
import 'dart:developer';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    log("Entered EditProfileScreen"); 
    return Scaffold(
      resizeToAvoidBottomInset: false, 
      appBar: AppBar(
        title: Text(
          'Customer Profile',
          style: TextStyle(fontSize: 20, color: Color(0xFFE8F0FE)),
        ),
        backgroundColor: Color(0xFF87027B),
        elevation: 0,
        automaticallyImplyLeading: true, 
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFE8F0FE)),
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
      
      body: Column(
        children: [
          SizedBox(height: 30),
          Stack(
            children: [
              CircleAvatar(
                radius: 50, 
                backgroundColor: Colors.grey[300],
                child: IconButton(
                  icon: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white, // Placeholder icon
                  ),
                  onPressed: () {
                    
                  },
                ),
              ),
              
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4), // Padding around the camera icon
                  decoration: BoxDecoration(
                    color: Colors.blue, // Background color
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2), // White border
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 15, // Camera icon size
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  CustomText(text: "Name"),
                  SizedBox(height: 10),
                  CustomTextField(hintText: "Name"),
                  SizedBox(height: 12),
                  CustomText(text: "Email"),
                  SizedBox(height: 10),
                  CustomTextField(hintText: "Email"),
                  SizedBox(height: 12),
                  CustomText(text: "Mobile Address"),
                  SizedBox(height: 10),
                  CustomTextField(hintText: "Mobile Address"),
                  SizedBox(height: 12),
                  CustomText(text: "Address"),
                  SizedBox(height: 10),
                  CustomTextField(hintText: "Address"),
                  SizedBox(height: 12),
                  CustomText(text: "Country/Region"),
                  SizedBox(height: 10),
                  CustomTextField(hintText: "Country/Region"),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF87027B),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        final overlay = Overlay.of(context);
                        final overlayEntry = OverlayEntry(
                          builder: (context) => Positioned(
                            top: 100, 
                            left: MediaQuery.of(context).size.width * 0.1,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "Profile settings saved successfully!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        );

                        overlay.insert(overlayEntry);

                        Future.delayed(Duration(seconds: 2), () {
                          overlayEntry.remove();
                        });
                      },
                      child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Roboto', fontWeight: FontWeight.w500,),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xFF000000),
        fontWeight: FontWeight.bold,
        fontSize: 14,
        fontFamily: 'Roboto',
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
        hintStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'Roboto', 
            color: Colors.black87.withAlpha(95),
          ),
        filled: true,
        fillColor: borderColor.withAlpha((0.2 * 255).toInt()),
        contentPadding: EdgeInsets.only(top: 1.0, bottom: 1.0, left: 10.0),
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
