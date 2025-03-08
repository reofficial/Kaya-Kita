
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
                    mainAxisSpacing: 15, crossAxisSpacing: 5,
                    children: [
                      // can be improved by having a mapping of jobs and icons
                      _buildJobCategory("Rider", Icons.motorcycle,
                        () {}
                      ),
                      _buildJobCategory("Driver", Icons.directions_car,
                        () {}
                      ),
                      _buildJobCategory("PasaBuy", Icons.food_bank,
                        () {}
                      ),
                      _buildJobCategory("Pabili", Icons.shopping_cart,
                        () {}
                      ),
                      _buildJobCategory("Laundry", Icons.local_laundry_service,
                        () {}
                      ),
                      _buildJobCategory("Balloon Artist", Icons.question_mark,
                        () {}
                      ),
                      _buildJobCategory("Home Cleaning", Icons.cleaning_services,
                        () {}
                      ),
                      _buildJobCategory("Aircon Tech", Icons.air,
                        () {}
                      ),
                      _buildJobCategory("Pet Groomer", Icons.shower,
                        () {}
                      ),
                      _buildJobCategory("Masseuse", Icons.bed,
                        () {}
                      ),
                      _buildJobCategory("Photographer", Icons.camera_alt,
                        () {}
                      ),
                      _buildJobCategory("Veterinarian", Icons.pets,
                        () {}
                      ),
                      _buildJobCategory("DJ", Icons.music_note,
                        () {}
                      ),
                      _buildJobCategory("Tutor", Icons.book,
                        () {}
                      ),
                      _buildJobCategory("Hair Stylist", Icons.question_mark,
                        () {}
                      ),
                      _buildJobCategory("Electrician", Icons.electrical_services,
                        () {}
                      ),
                      _buildJobCategory("Graphic Designer", Icons.draw,
                        () {}
                      ),
                      _buildJobCategory("Plumber", Icons.plumbing,
                        () {}
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Other services',
                        style: TextStyle(
                          color: Color(0xFF000000), 
                          fontWeight: FontWeight.bold,
                          fontSize: 20 
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {}, 
                        child: Text('BUTTON')
                      )
                    ],
                  ),

                  const Text(
                    'Loyalty',
                    style: TextStyle(
                      color: Color(0xFF000000), 
                      fontSize: 14 
                    ),
                  )
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
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis, // Avoids text overflow
            softWrap: true, 
          ),
        )
      ],
    );
  }
}