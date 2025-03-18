import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'mock_api_service.dart';

void main() {

  group('Edit Profile Tests: ', () {
    test('Valid edit profile details returns 200', () async {

      final Map<String, dynamic> updateDetails = {
        'current_email': 'user1@example.com',
        'first_name': 'newFirstName',
        'middle_initial': 'newMiddleInitial',
        'last_name': 'newLastName',
        'email': 'user1@example.com',
        'contact_number': '09987654321',
        'address': 'newAddress',
      };

      final response = await MockApiService.updateCustomer(updateDetails);

      expect(response.statusCode, 200);

      final responseBody = jsonDecode(response.body);
      expect(responseBody['message'], 'Customer updated successfully');
    });
  });
}
