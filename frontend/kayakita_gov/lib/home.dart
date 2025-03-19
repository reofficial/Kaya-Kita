import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kayakita_gov/certification.dart';
import 'joblistings.dart';

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
        title: const Text(
          "U.P. Campus, Quezon City",
          style: TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.bold, 
            color: Colors.white, 
          ),
        ),

        backgroundColor: const Color(0xFF000E53),
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

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Good day, Rowena!", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const Text("Inbox", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),

            Column(
              children: [
                _inboxButton("Job Listings", JobListingsScreen()),
                _inboxButton("Disputes", JobListingsScreen()), // PLS CHANGE WHEN DISPUTES SCREEN IS MADE
                _inboxButton("Certification", CertificationScreen()),
              ],
            ),
            const SizedBox(height: 20),

            _servicesCard(),
          ],
        ),
      ),
    );
  }

    Widget _inboxButton(String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          },
          child: Text(title, style: const TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ),
    );
  }


  Widget _servicesCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Services", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            SizedBox(height: 150, child: _buildBarChart()),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statCard("Ongoing", "3", Icons.flash_on),
                _statCard("Scheduled", "5", Icons.calendar_today),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statCard("Completed", "38", Icons.check_circle),
                _statCard("Total Bookings", "46", Icons.list_alt),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF000E53),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon and Title (Left Side, Centered)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(height: 4),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
            // Number (Right Side, Bigger Font, Centered Vertically)
            Text(
              value,
              style: const TextStyle(
                fontSize: 24, // Bigger font for emphasis
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildBarChart() {
  return BarChart(
    BarChartData(
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,  
            reservedSize: 40,  
            getTitlesWidget: (double value, TitleMeta meta) {
              return Text(value.toInt().toString(), style: const TextStyle(fontSize: 14));
            },
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), 
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              const days = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];
              return Text(days[value.toInt()], style: const TextStyle(fontSize: 12));
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: _getBarGroups(),
    ),
  );
}


  List<BarChartGroupData> _getBarGroups() {
    final data = [30, 25, 40, 55, 50, 60, 45]; 
    return List.generate(
      7,
      (index) => BarChartGroupData(x: index, barRods: [
        BarChartRodData(toY: data[index].toDouble(), color: index == 6 ? Colors.pink : Color(0xFF87027B), width: 30, borderRadius: BorderRadius.zero,),
      ]),
    );
  }
}