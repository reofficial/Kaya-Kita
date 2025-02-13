import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter/api_service.dart';

void main() {
  setUpAll(() async {
    // Load the environment variables for testing
    await dotenv.load(fileName: ".env");
  });

  group('Edit Profile Tests: ', () {
    test('Login user with valid credentials returns 200', () async {

      final Map<String, dynamic> updateDetails = {
        'current_email': 'email@domain.com',
        'first_name': 'newFirstName',
        'middle_initial': 'newMiddleInitial',
        'last_name': 'newLastName',
        'email': 'email@domain.com',
        'contact_number': '09987654321',
        'address': 'newAddress',
      };

      final response = await ApiService.updateCustomer(updateDetails);

      expect(response.statusCode, 200);

      final responseBody = jsonDecode(response.body);
      expect(responseBody['message'], 'Customer updated successfully');
    });
  });
}
