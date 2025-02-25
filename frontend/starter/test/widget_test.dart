import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter/home.dart' as homepage;
import 'package:starter/login.dart' as loginpage;
import 'package:starter/register.dart' as regpage;
import 'package:starter/main.dart'; 

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

  group ('Register screen:', () {
    testWidgets('User can enter email', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: regpage.RegisterScreen()));

      await tester.enterText(find.byType(TextField).first, 'email@domain.com');
      expect(find.text('email@domain.com'), findsOneWidget);
    });

    testWidgets('User can enter password', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: regpage.RegisterScreen()));

      await tester.enterText(find.byType(TextField).last, 'validpassword');
      expect(find.text('validpassword'), findsOneWidget);
    });

    testWidgets('Verify Continue button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: regpage.RegisterScreen()));

      expect(find.widgetWithText(ElevatedButton,'Continue'), findsOneWidget);
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

  group ('Home screen: ', () {
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

    group ('Home screen drawer: ', () {
      testWidgets('Verify Account header', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.textContaining('Account'), findsOneWidget);
      });

      testWidgets('Verify Edit Profile button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(ElevatedButton,'Edit Profile'), findsOneWidget);
      });

      testWidgets('Verify Security button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(ElevatedButton,'Security'), findsOneWidget);
      });

      testWidgets('Verify Notifications button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(ElevatedButton,'Notifications'), findsOneWidget);
      });

      testWidgets('Verify Privacy button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(ElevatedButton,'Privacy'), findsOneWidget);
      });


      testWidgets('Verify Support & About header', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.textContaining('Support & About'), findsOneWidget);
      });

      testWidgets('Verify My Subscription button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(ElevatedButton,'My Subscription'), findsOneWidget);
      });

      testWidgets('Verify Help & Support button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(ElevatedButton,'Help & Support'), findsOneWidget);
      });

      testWidgets('Verify Terms and Policies button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(ElevatedButton,'Terms and Policies'), findsOneWidget);
      });

      testWidgets('Verify Cache & Cellular header', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.textContaining('Cache & Cellular'), findsOneWidget);

        expect(find.widgetWithText(ElevatedButton,'Free up space'), findsOneWidget);
        expect(find.widgetWithText(ElevatedButton,'Data Saver'), findsOneWidget);
      });

      testWidgets('Verify Free up space button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(ElevatedButton,'Free up space'), findsOneWidget);
      });

      testWidgets('Verify Data Saver button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(ElevatedButton,'Data Saver'), findsOneWidget);
      });

      testWidgets('Verify Actions header', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.textContaining('Actions'), findsOneWidget);
      });

      testWidgets('Verify Report a problem button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(ElevatedButton,'Report a problem'), findsOneWidget);
      });

      testWidgets('Verify Add account button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(ElevatedButton,'Add account'), findsOneWidget);
      });

      testWidgets('Verify Log out button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(ElevatedButton,'Log out'), findsOneWidget);
      });
    });
  });
}