
import 'package:flutter/material.dart';

class JobCategoriesScreen extends StatefulWidget {
  const JobCategoriesScreen({super.key});

  @override
  State<JobCategoriesScreen> createState() => _JobCategoriesScreenState();
}

class _JobCategoriesScreenState extends State<JobCategoriesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Available services',
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildJobCategory(
                        "Rider", 
                        Icons.motorcycle,
                        () {}
                      ),
                      _buildJobCategory(
                        "Driver", 
                        Icons.directions_car,
                        () {}
                      ),
                      _buildJobCategory(
                        "PasaBuy", 
                        Icons.food_bank,
                        () {}
                      ),
                      _buildJobCategory(
                        "Pabili", 
                        Icons.shopping_cart,
                        () {}
                      ),
                      _buildJobCategory(
                        "Laundry", 
                        Icons.local_laundry_service,
                        () {}
                      ),
                      _buildJobCategory(
                        "More", 
                        Icons.more_horiz,
                        () {}
                      ),
                    ],
                  ),
                ]
              )
            )
          ]
        )
      )
    );
  }

  Widget _buildJobCategory(String title, IconData icon, VoidCallback onPressed) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Adjust corner radius
            ),
            padding: const EdgeInsets.all(10), // Ensures a square-like shape
            minimumSize: const Size(40, 40),
          ),
          child: Icon(
            icon, 
            size: 40, 
            color: Colors.grey[700]
          )
        ),
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