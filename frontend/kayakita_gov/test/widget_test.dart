import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayakita_gov/home.dart';
// import 'package:kayakita_gov/home.dart' as homepage;
import 'package:kayakita_gov/login.dart' as loginpage;
import 'package:kayakita_gov/main.dart';

void main() {
  group ('Onboarding screen:', () {
    testWidgets('Verify Log-in button', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp()); 

      expect(find.text('Log-in'), findsOneWidget);
    });

    testWidgets('Verify Create account button', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp()); 

      expect(find.text('Create account'), findsOneWidget);
    });
  });

  group ('Login screen: ', () {
    testWidgets('User can enter email', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: loginpage.LoginScreen()));

      await tester.enterText(find.byType(loginpage.CustomTextField).first, 'email@domain.com');
      expect(find.text('email@domain.com'), findsOneWidget);
    });

    testWidgets('User can enter password', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: loginpage.LoginScreen()));

      await tester.enterText(find.byType(TextField).last, 'validpassword');
      expect(find.text('validpassword'), findsOneWidget);
    });

    testWidgets('Verify Forgot password button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: loginpage.LoginScreen()));

      expect(find.widgetWithText(TextButton,'Forgot your password?'), findsOneWidget);
    });

    testWidgets('Verify Sign in button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: loginpage.LoginScreen()));

      expect(find.widgetWithText(ElevatedButton,'Sign in'), findsOneWidget);
    });

    testWidgets('Verify Create account button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: loginpage.LoginScreen()));

      expect(find.widgetWithText(TextButton,'Create a new account'), findsOneWidget);
    });

    testWidgets('Verify Forgot password button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: loginpage.LoginScreen()));

      expect(find.textContaining('Or continue with'), findsOneWidget);
    });

    testWidgets('Verify Google button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: loginpage.LoginScreen()));

      expect(find.image(AssetImage('assets/google.png')), findsOneWidget);
    });

    testWidgets('Verify Facebook button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: loginpage.LoginScreen()));

      expect(find.image(AssetImage('assets/facebook.png')), findsOneWidget);
    });

    testWidgets('Verify Apple button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: loginpage.LoginScreen()));

      expect(find.image(AssetImage('assets/apple.png')), findsOneWidget);
    });
  });
}