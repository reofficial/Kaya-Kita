import 'dart:convert';
import 'package:http/http.dart' as http;
import 'mock_data.dart';

class MockApiService {
  static final List<Map<String, dynamic>> _mockJobListings = mockJobListings;
  static final List<Map<String, dynamic>> _mockCustomers = mockCustomers;

  static Future<http.Response> createCustomer(Map<String, dynamic> customer) async {
    if (customer.isEmpty) {
      return http.Response(jsonEncode({'error': 'Invalid data'}), 400);
    }

    _mockCustomers.add({
      ...customer,
      'service_preference': customer['service_preference'] ?? 'N/A',
      'is_certified': customer['is_certified'] ?? false
    });

    return http.Response(jsonEncode({'message': 'Customer created successfully'}), 201);
  }

  static Future<http.Response> loginUser(String email, String password) async {
    final customer = _mockCustomers.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => {},
    );

    if (customer.isNotEmpty) {
      return http.Response(jsonEncode({'message': 'Login successful'}), 200);
    }

    return http.Response(jsonEncode({'detail': 'Invalid email or password'}), 401);
  }

  static Future<http.Response> updateCustomer(Map<String, dynamic> updateDetails) async {
    final index = _mockCustomers.indexWhere(
      (customer) => customer['email'] == updateDetails['email'],
    );

    if (index == -1) {
      return http.Response(jsonEncode({'error': 'Customer not found'}), 404);
    }

    _mockCustomers[index] = {
      ..._mockCustomers[index],
      ...updateDetails
    };

    return http.Response(jsonEncode({'message': 'Customer updated successfully'}), 200);
  }

  static Future<http.Response> getCustomers() async {
    return http.Response(jsonEncode(_mockCustomers), 200);
  }

  static Future<http.Response> getJobListings() async {
    return http.Response(jsonEncode([
      {'id': 1, 'title': 'Job 1', 'location': 'Manila'},
      {'id': 2, 'title': 'Job 2', 'location': 'Cebu'}
    ]), 200);
  }

  static Future<http.Response> getJobListing(int jobId) async {
    final job = _mockJobListings.firstWhere(
      (job) => job['id'] == jobId,
      orElse: () => {},
    );

    if (job.isNotEmpty) {
      return http.Response(jsonEncode(job), 200);
    }

    return http.Response(jsonEncode({'error': 'Job not found'}), 404);
  }

  static Future<http.Response> postJobListing(Map<String, dynamic> jobListing) async {
    if (jobListing['job_title'] == null) {
      return http.Response(jsonEncode({'error': 'Missing job title'}), 422);
    }

    _mockJobListings.add({
      'id': _mockJobListings.length + 1,
      ...jobListing,
    });

    return http.Response(jsonEncode({'message': 'Job listing created'}), 201);
  }

  static Future<http.Response> updateJobListing(Map<String, dynamic> updateDetails) async {
    final index = _mockJobListings.indexWhere((job) => job['id'] == updateDetails['id']);

    if (index == -1) {
      return http.Response(jsonEncode({'error': 'Job not found'}), 404);
    }

    _mockJobListings[index] = {
      ..._mockJobListings[index],
      ...updateDetails,
    };

    return http.Response(jsonEncode({'message': 'Job updated successfully'}), 200);
  }

  static Future<http.Response> deleteJobListing(int jobId) async {
    final index = _mockJobListings.indexWhere((job) => job['id'] == jobId);

    if (index == -1) {
      return http.Response(jsonEncode({'detail': 'Job listing not found'}), 404);
    }

    _mockJobListings.removeAt(index);
    return http.Response(jsonEncode({'message': 'Job listing deleted successfully'}), 200);
  }

  static Future<http.Response> getJobCircles() async {
    return http.Response(jsonEncode([
      {'id': 1, 'name': 'Job 1'},
      {'id': 2, 'name': 'Job 2'}
    ]), 200);
  }

  static Future<http.Response> postJobCircle(Map<String, dynamic> jobCircle) async {
    return http.Response(jsonEncode({'message': 'Job circle created'}), 201);
  }

  static Future<http.Response> getWorkers() async {
    return http.Response(jsonEncode([
      {'id': 1, 'name': 'Worker 1'},
      {'id': 2, 'name': 'Worker 2'}
    ]), 200);
  }

  static Future<http.Response> postReview(Map<String, dynamic> reviewDetails) async {
    return http.Response(jsonEncode({'message': 'Review posted successfully'}), 201);
  }
}
