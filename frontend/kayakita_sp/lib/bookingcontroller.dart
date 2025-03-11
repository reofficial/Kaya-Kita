import 'package:flutter/material.dart';

class BookingController extends ChangeNotifier {
  List<Map<String, dynamic>> bookings = [
    {
      "ticket_num": 4,
      "status": "Completed",
      "address": "Brgy 16, 1376 Sapilara Street Barracks 2, Caloocan",
      "amount": "₱400.00",
      "date": "20 Sept. 2024 - 3:00 PM",
      "customer": "Kamala Harris",
      "handyman": "Barack Obama",
      "payment": "Paid by Cash",
      "statusColor": Colors.purple,
      "actions": "Start Dispute",
    },
    {
      "ticket_num": 3,
      "status": "Pending",
      "address": "1103,1105 Rd. 2, Quezon City, Metro Manila, Philippines",
      "amount": "₱800.00",
      "date": "19 Sept. 2024 - 12:51 PM",
      "customer": "Luis de los Reyes",
      "handyman": "Barack Obama",
      "payment": "Paid by GCash",
      "statusColor": Colors.orange,
      "actions": "Accept/Deny",
    },
    {
      "ticket_num": 2,
      "status": "Pending",
      "address": "1103,1105 Rd. 2, Quezon City, Metro Manila, Philippines",
      "amount": "₱800.00",
      "date": "19 Sept. 2024 - 12:51 PM",
      "customer": "Luis de los Reyes",
      "handyman": "Barack Obama",
      "payment": "Paid by GCash",
      "statusColor": Colors.orange,
      "actions": "Accept/Deny",
    },
    {
      "ticket_num": 1,
      "status": "Accepted",
      "address": "28 Lt. J Francisco, Krus na Ligas, Diliman, Quezon City",
      "amount": "₱150.00",
      "date": "18 Sept. 2024 - 12:51 PM",
      "customer": "Donald Trump",
      "handyman": "Barack Obama",
      "payment": "Paid by GCash",
      "statusColor": Colors.green,
      "actions": null,
    },
  ];

  void updateBookingStatus(int index, String newStatus, Color newColor) {
    bookings[index]["status"] = newStatus;
    bookings[index]["statusColor"] = newColor;
    notifyListeners();
  }

//   void addTicketNumber4() {
//   print("Current bookings before adding: ${bookings.map((b) => b["ticket_num"]).toList()}");
//   bool exists = bookings.any((booking) => booking["ticket_num"] == 4);
  
//   if (exists) {
//     print("Ticket number 4 already exists.");
//     return;
//   }

//   bookings.add({
//     "ticket_num": 4,
//     "status": "Pending",
//     "address": "a",
//     "amount": "₱400.00",
//     "date": "20 Sept. 2024 - 3:00 PM",
//     "customer": "b",
//     "handyman": "c",
//     "payment": "Paid by Cash",
//     "statusColor": Colors.orange,
//     "actions": "Accept/Deny",
//   });

//   print("Updated bookings after adding: ${bookings.map((b) => b["ticket_num"]).toList()}");

//   bookings.sort((a, b) => (a["ticket_num"] as int).compareTo(b["ticket_num"] as int));

//   notifyListeners();
// }



}
