import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter/login.dart';
import 'package:starter/main.dart'; 

void main() {
  testWidgets('Verify login button appears on Onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp()); 

    expect(find.text('Log-in'), findsOneWidget);
  });

  testWidgets('User can enter email and password', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.enterText(find.byType(CustomTextField).first, 'email@domain.com');
    expect(find.text('email@domain.com'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'validpassword');
    expect(find.text('validpassword'), findsOneWidget);

    // Tap Login Button
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle(); 
  });
}