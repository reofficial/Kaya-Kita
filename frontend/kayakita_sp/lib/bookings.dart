import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:kayakita_sp/providers/profile_provider.dart';

import 'bookingcontroller.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String username =
        Provider.of<UserProvider>(context, listen: false).username;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookings"),
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: Provider.of<BookingController>(context, listen: false)
            .fetchBookings(username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          return Consumer<BookingController>(
            builder: (context, controller, child) {
              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: controller.bookings.length,
                itemBuilder: (context, index) {
                  var booking = controller.bookings[index];
                  print("Booking Data: $booking");

                  return _buildBookingCard(
                    context,
                    index,
                    booking["ticket_num"],
                    booking["status"],
                    booking["address"],
                    booking["amount"],
                    booking["date"],
                    booking["customer"],
                    booking["handyman"],
                    booking["payment"],
                    booking["statusColor"],
                    booking["actions"],
                    booking["is_certified"],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context,
    int index,
    int ticket_num,
    String status,
    String address,
    String amount,
    String date,
    String customer,
    String handyman,
    String payment,
    Color statusColor,
    String? actions,
    bool is_certified,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade600),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/smol_logo.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(status,
                        style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    const SizedBox(height: 4),
                    const Text("Service Fee",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey)),
                    Text(amount,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "#$ticket_num",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF93328E),
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (status == "Completed")
                      ElevatedButton(
                        onPressed: () {
                          // dispute logic
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFCAEC),
                            foregroundColor: Color(0xFFDF1995)),
                        child: const Text("Start Dispute"),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEDDFF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow("Address", address),
                  const Divider(),
                  _buildDetailRow("Date & Time", date),
                  const Divider(),
                  _buildDetailRow("Customer", customer),
                  const Divider(),
                  _buildDetailRow("Handyman", handyman),
                  const Divider(),
                  _buildDetailRow("Payment Status", payment,
                      textColor: Colors.green),
                ],
              ),
            ),
            if (status == "Pending")
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (!is_certified) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Certification expired."),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }
                        context
                            .read<BookingController>()
                            .updateBookingStatus(index, "Denied", Colors.red);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8D0010),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Deny"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (!is_certified) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Certification expired."),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }
                        context.read<BookingController>().updateBookingStatus(
                            index, "Accepted", Colors.green);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00B14F),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Accept"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value,
      {Color textColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 16, color: textColor, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
