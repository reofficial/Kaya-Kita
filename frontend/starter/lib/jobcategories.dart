
import 'package:flutter/material.dart';

class JobCategoriesScreen extends StatefulWidget {
  const JobCategoriesScreen({super.key});

  @override
  State<JobCategoriesScreen> createState() => _JobCategoriesScreenState();
}

class _JobCategoriesScreenState extends State<JobCategoriesScreen> {
  bool isSwitched = false; 

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
                crossAxisAlignment: CrossAxisAlignment.center,
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

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:[
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
                            _buildSwitch()
                          ],
                        ),

                        const Text(
                          'Loyalty',
                          style: TextStyle(
                            color: Color(0xFF000000), 
                            fontSize: 14 
                          ),
                        ),

                        SizedBox(height: 10),
                        
                        Row(
                          children:[
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.all(10),
                                minimumSize: const Size(40, 40),
                                backgroundColor: const Color.fromARGB(255, 255, 210, 253)
                              ),
                              child: Icon(Icons.star, size: 40, color: const Color(0xFF87027B))
                            ),

                            SizedBox(width: 10),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'KitaClub',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  ),
                                ),
                                Text(
                                  'Our new loyalty program',
                                  style: TextStyle(
                                    fontSize: 12
                                  ),
                                ),
                              ],
                            )
                          ]
                        )
                      ]
                    )
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
              borderRadius: BorderRadius.circular(16), 
            ),
            padding: const EdgeInsets.all(10), 
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
            overflow: TextOverflow.ellipsis, 
            softWrap: true, 
          ),
        )
      ],
    );
  }

  Widget _buildSwitch() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSwitched = !isSwitched;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: 70,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[300],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: AnimatedAlign(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: isSwitched ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            Padding (
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.grid_view_rounded, color: isSwitched ? Colors.grey : const Color.fromARGB(255, 70, 122, 72), size: 24),
                  Icon(Icons.list, color: isSwitched ? const Color.fromARGB(255, 70, 122, 72): Colors.grey, size: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}