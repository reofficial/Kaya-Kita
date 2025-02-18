import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter/home.dart' as homepage;
import 'package:starter/login.dart' as loginpage;
import 'package:starter/main.dart'; 

void main() {
  testWidgets('Verify Onboarding screen buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp()); 

    expect(find.text('Log-in'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });

  testWidgets('User can enter email and password in Register page', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: loginpage.LoginScreen()));

    await tester.enterText(find.byType(loginpage.CustomTextField).first, 'email@domain.com');
    expect(find.text('email@domain.com'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'validpassword');
    expect(find.text('validpassword'), findsOneWidget);

    // Tap Login Button
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle(); 
  });

  testWidgets('User can type in Home page search bar', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: homepage.HomeScreen()));

    await tester.enterText(find.byType(homepage.CustomTextField).first, 'searchquery');
    expect(find.text('searchquery'), findsOneWidget);
  });

  testWidgets('User can open Home page drawer', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
    await tester.pump(Duration(milliseconds: 200));

    await tester.tap(find.byIcon(Icons.account_circle));
    await tester.pumpAndSettle(); 

    expect(find.byType(Drawer), findsOneWidget);
  });

  // testWidgets('Verify Home page drawer buttons', (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
  //   await tester.pump(Duration(milliseconds: 200));

  //   await tester.tap(find.byIcon(Icons.account_circle));
  //   await tester.pumpAndSettle(); 

  //   expect(find.text('Account'), findsOneWidget);
  //   expect(find.text('Edit Profile'), findsOneWidget);
  //   expect(find.text('Security'), findsOneWidget);
  //   expect(find.text('Notifications'), findsOneWidget);
  //   expect(find.text('Privacy'), findsOneWidget);

  //   expect(find.text('Support & About'), findsOneWidget);
  //   expect(find.text('My Subscription'), findsOneWidget);
  //   expect(find.text('Help & Support'), findsOneWidget);
  //   expect(find.text('Terms and Policies'), findsOneWidget);

  //   expect(find.text('Cache & Cellular'), findsOneWidget);
  //   expect(find.text('Free up space'), findsOneWidget);
  //   expect(find.text('Data Saver'), findsOneWidget);

  //   expect(find.text('Actions'), findsOneWidget);
  //   expect(find.text('Report a problem'), findsOneWidget);
  //   expect(find.text('Add account'), findsOneWidget);
  //   expect(find.text('Log out'), findsOneWidget);

  // });

}