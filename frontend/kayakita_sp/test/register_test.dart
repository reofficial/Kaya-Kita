import 'package:flutter_test/flutter_test.dart';
import 'package:kayakita_sp/register.dart';

void main() {
  group('RegisterWorkerScreen Logic: ', () {
    final registerScreenState = RegisterWorkerScreenState();

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
      expect(registerScreenState.isValidEmail('test@example.com'), true);
      expect(registerScreenState.isValidEmail('invalid-email'), false);
      expect(registerScreenState.isValidEmail('missing@domain'), false);
    });

    test('Password matching', () {
      registerScreenState.passwordController.text = 'StrongP@ss1';
      registerScreenState.confirmPasswordController.text = 'StrongP@ss1';
      expect(registerScreenState.passwordController.text,
          registerScreenState.confirmPasswordController.text);
    });

    test('Mismatched passwords', () {
      registerScreenState.passwordController.text = 'StrongP@ss1';
      registerScreenState.confirmPasswordController.text = 'DifferentPass!';
      expect(registerScreenState.passwordController.text,
          isNot(registerScreenState.confirmPasswordController.text));
    });

    test('Empty password error', () {
      registerScreenState.passwordController.text = '';
      registerScreenState.confirmPasswordController.text = '';
      registerScreenState.onRegister();
      expect(registerScreenState.passwordError, 'Password cannot be empty');
    });

    test('Password does not meet criteria', () {
      registerScreenState.passwordController.text = 'weak';
      registerScreenState.confirmPasswordController.text = 'weak';
      registerScreenState.onRegister();
      expect(registerScreenState.passwordError,
          'Password does not meet all requirements');
    });

    test('Successful registration validation', () {
      registerScreenState.emailController.text = 'worker@test.com';
      registerScreenState.passwordController.text = 'StrongP@ss1';
      registerScreenState.confirmPasswordController.text = 'StrongP@ss1';

      registerScreenState.onRegister();

      expect(registerScreenState.emailError, isNull);
      expect(registerScreenState.passwordError, isNull);
    });

    test('Duplicate email error', () async {
      registerScreenState.emailController.text = 'existing@test.com';
      registerScreenState.passwordController.text = 'ValidP@ss123';
      registerScreenState.confirmPasswordController.text = 'ValidP@ss123';

      await registerScreenState.onRegister();

      expect(registerScreenState.emailError,
          'Email already exists. Please use a different one.');
    });
  });
}
