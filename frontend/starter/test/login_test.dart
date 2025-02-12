import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter/api_service.dart';

void main() {
  setUpAll(() async {
    // Load the environment variables for testing
    await dotenv.load(fileName: ".env");
  });

  group('Login Tests: ', () {
    test('Login user with valid credentials returns 200', () async {

      const testEmail = 'email@domain.com';
      const testPassword = 'validpassword';

      final response = await ApiService.loginUser(testEmail, testPassword);

      expect(response.statusCode, 200);

      final responseBody = jsonDecode(response.body);
      expect(responseBody['message'], 'Login successful');
    });

    test('Login user with invalid credentials returns 401', () async {

      const testEmail = 'invalid@example.com';
      const testPassword = 'wrongpassword';

      final response = await ApiService.loginUser(testEmail, testPassword);

      expect(response.statusCode, 401);

      final responseBody = jsonDecode(response.body);
      expect(responseBody['detail'], 'Invalid email or password');
    });
  });
}
