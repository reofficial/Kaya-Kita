import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class ApiService {
  static final String baseUrl =
      dotenv.env['BACKEND_URL'] ?? "http://localhost:8000";

  // Create an IOClient that ignores SSL errors
  static final IOClient _client = IOClient(
    HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true,
  );

  static Future<http.Response> registerUser(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/customers/email');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return response;
  }

  static Future<http.Response> createCustomer(
      Map<String, dynamic> customer) async {
    final url = Uri.parse('$baseUrl/customers/register');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(customer),
    );

    return response;
  }

  static Future<http.Response> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/customers/login');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return response;
  }

  static Future<http.Response> updateCustomer(
      Map<String, dynamic> updateDetails) async {
    final url = Uri.parse('$baseUrl/customers/update');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateDetails),
    );
    return response;
  }

  static Future<http.Response> getCustomers() async {
    final url = Uri.parse('$baseUrl/customers');
    final response = await _client.get(url);
    return response;
  }

  static Future<http.Response> getJobListings() async {
    final url = Uri.parse('$baseUrl/job-listings');
    final response = await _client.get(url);
    return response;
  }

  static Future<http.Response> getJobListing(int jobId) async {
    final url = Uri.parse('$baseUrl/job-listings/job-id/$jobId');
    final response = await _client.get(url);
    return response;
  }

  static Future<http.Response> postJobListing(
      Map<String, dynamic> jobListing) async {
    final url = Uri.parse('$baseUrl/job-listings/post');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jobListing),
    );
    return response;
  }

  static Future<http.Response> updateJobListing(
      Map<String, dynamic> updateDetails) async {
    final url = Uri.parse('$baseUrl/job-listings/update');
    final response = await _client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateDetails),
    );
    return response;
  }

  static Future<http.Response> deleteJobListing(int jobId) async {
    final url = Uri.parse('$baseUrl/job-listings/delete/$jobId');
    final response = await _client.delete(url);
    return response;
  }

  static Future<http.Response> getJobCircles() async {
    final url = Uri.parse('$baseUrl/job-circles');
    final response = await _client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  static Future<http.Response> updateJobCircle(
      Map<String, dynamic> updateDetails) async {
    final url = Uri.parse('$baseUrl/job-circles/update');
    final response = await _client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateDetails),
    );
    return response;
  }

  static Future<http.Response> postJobCircle(
      Map<String, dynamic> jobCircle) async {
    final url = Uri.parse('$baseUrl/job-circles/post');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jobCircle),
    );
    return response;
  }

  static Future<http.Response> getWorkers() async {
    final url = Uri.parse('$baseUrl/workers');
    final response = await _client.get(url);
    return response;
  }

  static Future<http.Response> postReview(
      Map<String, dynamic> reviewDetails) async {
    final url = Uri.parse('$baseUrl/reviews/create');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reviewDetails),
    );
    return response;
  }

  static Future<http.Response> getOfficials() async {
    final url = Uri.parse('$baseUrl/officials');
    final response = await _client.get(url);
    return response;
  }

  static Future<http.Response> postDispute(
      Map<String, dynamic> jobListing) async {
    final url = Uri.parse('$baseUrl/disputes/create');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jobListing),
    );
    return response;
  }

  static Future<http.Response> updateDisputes(
      Map<String, dynamic> updateDetails) async {
    final url = Uri.parse('$baseUrl/disputes/update');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateDetails),
    );
    return response;
  }

  static Future<http.Response> getDisputes() async {
    final url = Uri.parse('$baseUrl/disputes');
    final response = await _client.get(url);
    return response;
  }

  static Future<http.Response> getChats() async {
    final url = Uri.parse('$baseUrl/chat');
    final response = await _client.get(url);
    return response;
  }

  static Future<http.Response> createChat(
      Map<String, dynamic> chatDetails) async {
    final url = Uri.parse('$baseUrl/chat/create');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(chatDetails),
    );
    return response;
  }

  static Future<http.Response> updateChat(
    Map<String, dynamic> chatDetails,
    String newMessage,
    String username,
  ) async {
    final newMessageEntry = {username: newMessage};
    final updatedChat = Map<String, dynamic>.from(chatDetails);
    updatedChat['chat'] = [
      ...chatDetails['chat'] ?? [],
      newMessageEntry,
    ];

    final url = Uri.parse('$baseUrl/chat/update');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedChat),
    );
    return response;
  }
}
