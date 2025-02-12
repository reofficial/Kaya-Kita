import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class ApiService {
  static final String baseUrl = dotenv.env['BACKEND_URL'] ?? "http://localhost:8000";

  // Create an IOClient that ignores SSL errors
  static final IOClient _client = IOClient(
    HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true,
  );

  static Future<http.Response> registerUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/customers/email');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return response;
  }

  static Future<http.Response> createCustomer(Map<String, dynamic> customer) async {
    final url = Uri.parse('$baseUrl/customers/register');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(customer),
    );

    return response;
  }


}
