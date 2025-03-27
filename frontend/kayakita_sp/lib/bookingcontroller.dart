import 'package:flutter/material.dart';
import 'api_service.dart';
import 'dart:convert';

class BookingController extends ChangeNotifier {
  List<Map<String, dynamic>> bookings = [];

  Future<void> fetchBookings(String handymanUsername) async {
    try {
      final jobCirclesResponse = await ApiService.getJobCircles();
      final customersResponse = await ApiService.getCustomers();
      final workersResponse = await ApiService.getWorkers();

      if (jobCirclesResponse.statusCode == 200 &&
          customersResponse.statusCode == 200 &&
          workersResponse.statusCode == 200) {
        List<dynamic> jobCirclesData = jsonDecode(jobCirclesResponse.body);
        List<dynamic> customersData = jsonDecode(customersResponse.body);
        List<dynamic> workersData = jsonDecode(workersResponse.body);

        final matchedWorker = workersData
            .firstWhere((item) => item['username'] == handymanUsername);

        Map<String, String> customerAddressMap = {
          for (var customer in customersData)
            customer["username"]: customer["address"]
        };

        // Filter bookings for the logged-in handyman
        bookings = jobCirclesData
            .where((booking) => booking["handyman"] == handymanUsername)
            .map((booking) {
          String customerUsername = booking["customer"];
          String handymanUsername = booking["handyman"];

          return {
            "ticket_num": booking["ticket_number"],
            "status": booking["job_status"],
            "address": customerAddressMap[customerUsername] ?? "N/A",
            "amount": "₱100.00",
            "date": booking["datetime"],
            "customer": customerUsername,
            "handyman": handymanUsername,
            "payment": booking["payment_status"],
            "statusColor": _getStatusColor(booking["job_status"]),
            "actions": "Pending",
            "is_certified": matchedWorker['is_certified'],
          };
        }).toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load bookings, customers, or workers');
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

  Future<void> updateBookingStatus(
      int index, String newStatus, Color color) async {
    try {
      String ticketNum = bookings[index]["ticket_num"].toString();
      String datetime = bookings[index]["date"].toString();
      String customer = bookings[index]["customer"].toString();
      String handyman = bookings[index]["handyman"].toString();

      Map<String, dynamic> requestBody = {
        "ticket_number": ticketNum,
        "job_status": newStatus,
        "datetime": datetime,
        "customer": customer,
        "handyman": handyman,
      };

      print("Sending request: $requestBody");

      final response = await ApiService.updateJobCircles(requestBody);

      print("API Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        bookings[index]["status"] = newStatus;
        bookings[index]["statusColor"] = color;
        bookings[index]["actions"] =
            newStatus == "Accepted" ? "Ongoing" : "Denied";

        notifyListeners();
      } else {
        print("Failed to update job status: ${response.body}");
      }
    } catch (e) {
      print("Error updating job status: $e");
    }
  }

  int get pendingBookingsCount {
    return bookings.where((booking) => booking["status"] == "Pending").length;
  }
}
