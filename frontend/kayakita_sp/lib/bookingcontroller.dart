import 'package:flutter/material.dart';
import 'api_service.dart';
import 'dart:convert';

class BookingController extends ChangeNotifier {
  List<Map<String, dynamic>> bookings = [];

  Future<void> fetchBookings() async {
    try {
      final jobCirclesResponse = await ApiService.getJobCircles();
      final customersResponse = await ApiService.getCustomers();

      if (jobCirclesResponse.statusCode == 200 && customersResponse.statusCode == 200) {
        List<dynamic> jobCirclesData = jsonDecode(jobCirclesResponse.body);
        List<dynamic> customersData = jsonDecode(customersResponse.body);

        Map<String, String> customerAddressMap = {
          for (var customer in customersData) customer["username"]: customer["address"]
        };

        bookings = jobCirclesData.map((booking) {
          String customerUsername = booking["customer"];
          return {
            "ticket_num": booking["ticket_number"],
            "status": booking["job_status"],
            "address": customerAddressMap[customerUsername] ?? "N/A", 
            "amount": "₱100.00",
            "date": booking["datetime"],
            "customer": customerUsername,
            "handyman": booking["handyman"],
            "payment": booking["payment_status"],
            "statusColor": _getStatusColor(booking["job_status"]),
            "actions": "Pending"
          };
        }).toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load bookings or customers');
      }
    } catch (e) {
      print("Error fetching bookings: $e");
    }
  }


  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Accepted":
        return Colors.green;
      case "Denied":
        return Colors.red;
      case "Completed":
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  Future<void> updateBookingStatus(int index, String newStatus, Color color) async {
  try {
    String ticketNum = bookings[index]["ticket_num"].toString(); 
    String datetime = bookings[index]["date"].toString(); 
    String customer = bookings[index]["customer"].toString(); 

    Map<String, dynamic> requestBody = {
      "ticket_number": ticketNum,
      "job_status": newStatus,
      "datetime": datetime,  
      "customer": customer   
    };

   // print("Sending request: $requestBody"); 

    final response = await ApiService.updateJobCircles(requestBody);

    print("API Response: ${response.statusCode} - ${response.body}"); 

    if (response.statusCode == 200) {
      bookings[index]["status"] = newStatus;
      bookings[index]["statusColor"] = color;
      bookings[index]["actions"] = newStatus == "Accepted" ? "Ongoing" : "Denied";

      notifyListeners();
    } else {
      print("Failed to update job status: ${response.body}");
    }
  } catch (e) {
    print("Error updating job status: $e");
  }
}


}
