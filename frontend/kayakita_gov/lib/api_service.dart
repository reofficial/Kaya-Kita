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
    final url = Uri.parse('$baseUrl/officials/email');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return response;
  }

  static Future<http.Response> createOfficial(
      Map<String, dynamic> official) async {
    final url = Uri.parse('$baseUrl/officials/register');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(official),
    );

    return response;
  }

  static Future<http.Response> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/officials/login');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return response;
  }

  static Future<http.Response> updateOfficial(
      Map<String, dynamic> updateDetails) async {
    final url = Uri.parse('$baseUrl/officials/update');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateDetails),
    );

    return response;
  }

  static Future<http.Response> getOfficials() async {
    final url = Uri.parse('$baseUrl/officials');
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

  static Future<http.Response> getWorkers() async {
    final url = Uri.parse('$baseUrl/workers');
    final response = await _client.get(url);
    return response;
  }
}
