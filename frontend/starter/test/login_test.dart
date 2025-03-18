import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'mock_api_service.dart';

void main() {

  group('Login Tests: ', () {
    test('Login user with valid credentials returns 200', () async {

      const testEmail = 'user1@example.com';
      const testPassword = 'password123';

      final response = await MockApiService.loginUser(testEmail, testPassword);

      expect(response.statusCode, 200);

      final responseBody = jsonDecode(response.body);
      expect(responseBody['message'], 'Login successful');
    });

    test('Login user with invalid credentials returns 401', () async {

      const testEmail = 'invalid@example.com';
      const testPassword = 'wrongpassword';

      final response = await MockApiService.loginUser(testEmail, testPassword);

      expect(response.statusCode, 401);

      final responseBody = jsonDecode(response.body);
      expect(responseBody['detail'], 'Invalid email or password');
    });
  });
}
