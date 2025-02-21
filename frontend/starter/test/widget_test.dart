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

  group ('Home page drawer tests: ', () {
    testWidgets('Verify Account section', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
      await tester.pump(Duration(milliseconds: 200));

      await tester.tap(find.byIcon(Icons.account_circle));
      await tester.pumpAndSettle(); 

      expect(find.textContaining('Account'), findsOneWidget);

      expect(find.widgetWithText(ElevatedButton,'Edit Profile'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton,'Security'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton,'Notifications'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton,'Privacy'), findsOneWidget);
    });

    testWidgets('Verify Support & About section', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
      await tester.pump(Duration(milliseconds: 200));

      await tester.tap(find.byIcon(Icons.account_circle));
      await tester.pumpAndSettle(); 

      expect(find.textContaining('Support & About'), findsOneWidget);

      expect(find.widgetWithText(ElevatedButton,'My Subscription'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton,'Help & Support'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton,'Terms and Policies'), findsOneWidget);
    });

    testWidgets('Verify Cache & Cellular section', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
      await tester.pump(Duration(milliseconds: 200));

      await tester.tap(find.byIcon(Icons.account_circle));
      await tester.pumpAndSettle(); 

      expect(find.textContaining('Cache & Cellular'), findsOneWidget);

      expect(find.widgetWithText(ElevatedButton,'Free up space'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton,'Data Saver'), findsOneWidget);
    });

    testWidgets('Verify Actions section', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
      await tester.pump(Duration(milliseconds: 200));

      await tester.tap(find.byIcon(Icons.account_circle));
      await tester.pumpAndSettle(); 

      expect(find.textContaining('Actions'), findsOneWidget);

      expect(find.widgetWithText(ElevatedButton,'Report a problem'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton,'Add account'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton,'Log out'), findsOneWidget);
    });

  });

}