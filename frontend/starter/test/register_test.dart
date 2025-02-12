import 'package:flutter_test/flutter_test.dart';
import 'package:starter/register.dart';

void main() {

  group('RegisterScreen Logic: ', () {

    final registerScreenState = RegisterScreenState();

    test('Valid password flags', () {
      final flags = registerScreenState.validatePasswordFlags('Abc!123');
      expect(flags['hasMinLength'], true);
      expect(flags['hasUpperCase'], true);
      expect(flags['hasNumber'], true);
      expect(flags['hasSpecialChar'], true);
    });

    test('Invalid password flags', () {
      final flags = registerScreenState.validatePasswordFlags('abc');
      expect(flags['hasMinLength'], false);
      expect(flags['hasUpperCase'], false);
      expect(flags['hasNumber'], false);
      expect(flags['hasSpecialChar'], false);
    });

    test('Email validation', () {
      final registerScreenState = RegisterScreenState();

      expect(registerScreenState.isValidEmail('test@example.com'), true);

      expect(registerScreenState.isValidEmail('test'), false);
      expect(registerScreenState.isValidEmail('test@.com'), false);
    });
  });

}