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

  // JOB LISTINGS
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

  static Future<http.Response> getCustomers() async {
    final url = Uri.parse('$baseUrl/customers');
    final response = await _client.get(url);
    return response;
  }

  // WORKERS
  static Future<http.Response> getWorkers() async {
    final url = Uri.parse('$baseUrl/workers');
    final response = await _client.get(url);
    return response;
  }

  static Future<http.Response> updateWorker(
      Map<String, dynamic> updateDetails) async {
    final url = Uri.parse('$baseUrl/workers/update');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateDetails),
    );
    return response;
  }

  // CERTIFICATION

  static Future<http.Response> getCertifications() async {
    final url = Uri.parse('$baseUrl/certifications');
    final response = await _client.get(url);
    return response;
  }

  static Future<http.Response> getCertificationByUsername(
      String workerUsername) async {
    final url = Uri.parse('$baseUrl/certifications/$workerUsername');
    final response = await _client.get(url);
    return response;
  }

  static Future<http.Response> getCustomerReviews(String username) async {
    final url = Uri.parse('$baseUrl/reviews/$username');
    final response = await _client.get(url);
    return response;
  }

  static Future<http.Response> getWorkerReviews(String username) async {
    final url = Uri.parse('$baseUrl/reviews/worker/$username');
    final response = await _client.get(url);
    return response;
  }

  static Future<http.Response> updateUserSuspension(
      String username, String status, String reason, bool isWorker) async {
    final url = isWorker
        ? Uri.parse('$baseUrl/update_suspension_worker')
        : Uri.parse('$baseUrl/update_suspension_customer');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'is_suspended': status,
        'suspension_reason': reason
      }),
    );
    return response;
  }

  static Future<http.Response> getAuditLogs() async {
    final url = Uri.parse('$baseUrl/logs');
    final response = await _client.get(url);
    return response;
  }

  static Future<http.Response> getAuditLogsByUsername(String username) async {
    final url = Uri.parse('$baseUrl/logs/$username');
    final response = await _client.get(url);
    return response;
  }

  static Future<http.Response> createLog({
    required String officialUsername,
    required String log,
  }) async {
    final url = Uri.parse('$baseUrl/logs/create');

    return await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'official_username': officialUsername,
        'log': log,
      }),
    );
  }

  static Future<http.Response> getDisputes() async {
    final url = Uri.parse('$baseUrl/disputes');
    final response = await _client.get(url);
    return response;
  }

  static Future<http.Response> updateDispute(
      Map<String, dynamic> updateDetails) async {
    final url = Uri.parse('$baseUrl/disputes/update');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updateDetails),
    );
    return response;
  }
}
