import 'package:flutter/material.dart';

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

  const JobListingCard({super.key, required this.job});

  @override
  _JobListingCardState createState() => _JobListingCardState();
}

class _JobListingCardState extends State<JobListingCard> {
  late String status;

  @override
  void initState() {
    super.initState();
    status = widget.job.status;
  }

  void updateStatus(String newStatus) {
    setState(() {
      status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.job.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 3),
              OutlinedButton(
                onPressed: () {
                },
                style: OutlinedButton.styleFrom(
                  // backgroundColor: const Color(0xFF87027B), 
                  // foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF87027B)), 
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    const Text(
                      "View",
                      style: TextStyle(color: Color(0xFF87027B), fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    //const SizedBox(width: 2), 
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF87027B)),
                  ],
                ),
              ),

            ],
          ),


            const SizedBox(height: 4),
            Text(widget.job.description, style: TextStyle(color: Colors.grey[800])),
            const SizedBox(height: 8),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Customer:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(widget.job.customer, style: const TextStyle(color: Color(0xFF87027B), fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Address:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Expanded(child: Text(widget.job.address, textAlign: TextAlign.right, style: const TextStyle(fontSize: 16))),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Posted:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(widget.job.postedDate, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Rate:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(widget.job.rate, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            status == 'Accepted' || status == 'Denied'
                ? Center(
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: status == 'Accepted' ? Color(0xFF00880C) : Color(0xFF8D0010),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => updateStatus('Accepted'),
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF00880C),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        ),
                        child: const Text('Accept', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => updateStatus('Denied'),
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFF8D0010),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
      title: 'joe biden',
      description: 'job iden',
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
      title: 'joe biden',
      description: 'biden blast!!',
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
      appBar: AppBar(title: const Text('Job Listings')),
      body: ListView.builder(
        itemCount: jobListings.length,
        itemBuilder: (context, index) {
          return JobListingCard(job: jobListings[index]);
        },
      ),
    );
  }
}