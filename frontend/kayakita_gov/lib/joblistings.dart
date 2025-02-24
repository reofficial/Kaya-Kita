import 'package:flutter/material.dart';
import 'viewpost.dart';

class JobListing {
  final String title;
  final String description;
  final String customer;
  final String address;
  final String postedDate;
  final String rate;
  String status;

  JobListing({
    required this.title,
    required this.description,
    required this.customer,
    required this.address,
    required this.postedDate,
    required this.rate,
    required this.status,
  });
}

class JobListingCard extends StatefulWidget {
  final JobListing job;
  const JobListingCard({Key? key, required this.job}) : super(key: key);

  @override
  _JobListingCardState createState() => _JobListingCardState();
}

class _JobListingCardState extends State<JobListingCard> {
  void updateStatus(String newStatus) {
    if (widget.job.status == 'Accepted' || widget.job.status == 'Denied') return;
    setState(() {
      widget.job.status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              widget.job.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000E53),
              ),
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              widget.job.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            const SizedBox(height: 16),
            // Customer info with icon
            Row(
              children: [
                const Icon(Icons.person, color: Color(0xFF000E53)),
                const SizedBox(width: 8),
                Text(
                  widget.job.customer,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Address info with icon
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.redAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.job.address,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Posted date with icon
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  widget.job.postedDate,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Rate info with icon
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  widget.job.rate,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Status and actions section
            if (widget.job.status == 'Accepted')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Accepted',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewPostScreen()),
                      );
                    },
                    icon: const Icon(Icons.visibility, color: Colors.white),
                    label: const Text('View'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000E53),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              )
            else if (widget.job.status == 'Denied')
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.cancel, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Denied',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => updateStatus('Accepted'),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF00880C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Accept', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => updateStatus('Denied'),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF8D0010),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Deny', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class JobListingsScreen extends StatelessWidget {
  JobListingsScreen({Key? key}) : super(key: key);

  final List<JobListing> jobListings = [
    JobListing(
      title: 'Florist for Wedding Reception',
      description: 'Experienced florist needed for a wedding reception.',
      customer: 'Donald Trump',
      address: 'University Hotel, U.P. Campus',
      postedDate: 'October 5, 2024 - 12:01 PM',
      rate: '₱10,000/Monthly',
      status: '',
    ),
    JobListing(
      title: 'Joe Biden Event',
      description: 'High profile event requiring special arrangements.',
      customer: 'Joe Biden',
      address: 'University Health Service, U.P. Campus',
      postedDate: 'October 6, 2024 - 8:27 PM',
      rate: '₱150/Hourly',
      status: '',
    ),
    JobListing(
      title: 'Personal Chef Wanted',
      description: 'Looking for a personal chef for my kids.',
      customer: 'Kamala Harris',
      address: '45 Juan Luna Street, U.P. Campus',
      postedDate: 'October 1, 2024 - 11:11 PM',
      rate: '₱30,000/Monthly',
      status: 'Accepted',
    ),
    JobListing(
      title: 'Joe Biden Special Request',
      description: 'Exclusive request with high compensation.',
      customer: 'Joe Biden',
      address: 'University Hotel, U.P. Campus',
      postedDate: 'September 21, 2024 - 5:21 PM',
      rate: '₱1,000,000/Daily',
      status: 'Denied',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          'Job Listings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF000E53),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: jobListings.length,
        itemBuilder: (context, index) {
          return JobListingCard(job: jobListings[index]);
        },
      ),
    );
  }
}
