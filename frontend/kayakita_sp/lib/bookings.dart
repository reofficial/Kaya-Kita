import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bookingcontroller.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Bookings"),
          backgroundColor: Colors.purple,
        ),
        body: Consumer<BookingController>(
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
                  booking["actions"] ?? "No Actions",
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
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade600), // Greyish border
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row containing the logo, status block, and action button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo on the left
                Image.asset(
                  'assets/smol_logo.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),

                // Status, Service Fee, and Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    const Text("Service Fee", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey)),
                    Text(amount, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

                // Show "Start Dispute" button only if status is Completed
                if (status == "Completed")
                  ElevatedButton(
                    onPressed: () {
                      // Handle dispute logic
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFCAEC), foregroundColor: Color(0xFFDF1995)),
                    child: const Text("Start Dispute"),
                  ),
              ],
            ),
          ],
        ),

            const SizedBox(height: 10),

            // Address and Details inside a box with separators
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEDDFF), // Set background color
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
                  _buildDetailRow("Payment Status", payment, textColor: Colors.green),
                ],
              ),
            ),

            // Show "Accept/Deny" buttons only if status is Pending
            if (status == "Pending")
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<BookingController>().updateBookingStatus(index, "Denied", Colors.red);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8D0010), foregroundColor: Colors.white),
                      child: const Text("Deny"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<BookingController>().updateBookingStatus(index, "Accepted", Colors.green);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00B14F), foregroundColor: Colors.white),
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


  Widget _buildDetailRow(String title, String value, {Color textColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Increased font size
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right, // Aligns text to the right
              style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w500), // Increased font size
            ),
          ),
        ],
      ),
    );
  }
}
