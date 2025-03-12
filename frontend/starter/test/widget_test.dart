import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:starter/home.dart' as homepage;
import 'package:starter/jobcategories.dart' as jobcategoriespage;
import 'package:starter/jobinfo.dart' as jobinfopage;
import 'package:starter/joblistings.dart' as joblistpage;
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

  group ('Home screen:', () {
    testWidgets('User can type in Home page search bar', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: homepage.HomeScreen()));

      await tester.enterText(find.byType(homepage.CustomTextField).first, 'searchquery');
      expect(find.text('searchquery'), findsOneWidget);
    });

    testWidgets('Verify wallet section', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: homepage.HomeScreen()));

      expect(find.widgetWithText(Container, 'Wallet'), findsOneWidget);
    });

    testWidgets('Verify promos image', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: homepage.HomeScreen()));

      expect(find.image(AssetImage('assets/promos.png')), findsOneWidget);
    });

    testWidgets('Verify promos submit entry button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: homepage.HomeScreen()));

      expect(find.widgetWithText(TextButton, 'Submit entry'), findsOneWidget);
    });

    testWidgets('User can open Home page drawer', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
      await tester.pump(Duration(milliseconds: 200));
      await tester.tap(find.byIcon(Icons.account_circle));
      await tester.pumpAndSettle(); 

      expect(find.byType(Drawer), findsOneWidget);
    });

    // CAN BE CHANGED THROUGHOUT DEVELOPMENT
    group ('Home screen explore section:', () {
      testWidgets('Verify Rider icon', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: homepage.HomeScreen()));
        
        expect(find.byIcon(Icons.motorcycle), findsOneWidget);
      });

      testWidgets('Verify Driver icon', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: homepage.HomeScreen()));
        
        expect(find.byIcon(Icons.directions_car), findsOneWidget);
      });

      testWidgets('Verify PasaBuy icon', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: homepage.HomeScreen()));
        
        expect(find.byIcon(Icons.food_bank), findsOneWidget);
      });

      testWidgets('Verify Pabili icon', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: homepage.HomeScreen()));
        
        expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      });

      testWidgets('Verify Laundry icon', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: homepage.HomeScreen()));
        
        expect(find.byIcon(Icons.local_laundry_service), findsOneWidget);
      });

      testWidgets('Verify More icon', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: homepage.HomeScreen()));
        
        expect(find.byIcon(Icons.more_horiz), findsOneWidget);
      });
    });

    group ('Home screen drawer:', () {
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

        expect(find.widgetWithText(homepage.SidebarButton,'Edit Profile'), findsOneWidget);
      });

      testWidgets('Verify Security button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(homepage.SidebarButton,'Security'), findsOneWidget);
      });

      testWidgets('Verify Notifications button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(homepage.SidebarButton,'Notifications'), findsOneWidget);
      });

      testWidgets('Verify Privacy button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(homepage.SidebarButton,'Privacy'), findsOneWidget);
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

        expect(find.widgetWithText(homepage.SidebarButton,'My Subscription'), findsOneWidget);
      });

      testWidgets('Verify Help & Support button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(homepage.SidebarButton,'Help & Support'), findsOneWidget);
      });

      testWidgets('Verify Terms and Policies button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(homepage.SidebarButton,'Terms and Policies'), findsOneWidget);
      });

      testWidgets('Verify Cache & Cellular header', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.textContaining('Cache & Cellular'), findsOneWidget);
      });

      testWidgets('Verify Free up space button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(homepage.SidebarButton,'Free up space'), findsOneWidget);
      });

      testWidgets('Verify Data Saver button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(homepage.SidebarButton,'Data Saver'), findsOneWidget);
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

        expect(find.widgetWithText(homepage.SidebarButton,'Report a problem'), findsOneWidget);
      });

      testWidgets('Verify Add account button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(homepage.SidebarButton,'Add account'), findsOneWidget);
      });

      testWidgets('Verify Log out button', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: homepage.HomeScreen()));
        await tester.pump(Duration(milliseconds: 200));
        await tester.tap(find.byIcon(Icons.account_circle));
        await tester.pumpAndSettle(); 

        expect(find.widgetWithText(homepage.SidebarButton,'Log out'), findsOneWidget);
      });
    });
  });

  group ('Job Listings screen:', () {

    testWidgets('Verify add post icon button', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: joblistpage.JobListingsScreen()));

      expect(find.widgetWithIcon(IconButton, Icons.add_circle), findsOneWidget);
    });
  });

  group ('Job Categories screen:', () {

    testWidgets('Verify Biker icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.motorcycle), findsOneWidget);
    });

    testWidgets('Verify Driver icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.directions_car), findsOneWidget);
    });

    testWidgets('Verify PasaBuy icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.food_bank), findsOneWidget);
    });

    testWidgets('Verify Pabili icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('Verify Laundry icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.local_laundry_service), findsOneWidget);
    });

    testWidgets('Verify Balloon Artist icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.question_mark), findsOneWidget);
    });

    testWidgets('Verify Home Cleaning icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.cleaning_services), findsOneWidget);
    });

    testWidgets('Verify Aircon Tech icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.air), findsOneWidget);
    });

    testWidgets('Verify Pet Groomer icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.shower), findsOneWidget);
    });

    testWidgets('Verify Masseuse icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.bed), findsOneWidget);
    });

    testWidgets('Verify Photographer icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.camera_alt), findsOneWidget);
    });

    testWidgets('Verify Veterinarian icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.pets), findsOneWidget);
    });

    testWidgets('Verify DJ icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.music_note), findsOneWidget);
    });

    testWidgets('Verify Tutor icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.book), findsOneWidget);
    });

    testWidgets('Verify Hair Stylist icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, FontAwesomeIcons.scissors), findsOneWidget);
    });

    testWidgets('Verify Electrician icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.electrical_services), findsOneWidget);
    });

    testWidgets('Verify Graphic Designer icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.draw), findsOneWidget);
    });

    testWidgets('Verify Plumber icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: jobcategoriespage.JobCategoriesScreen()));

      expect(find.widgetWithIcon(ElevatedButton, Icons.plumbing), findsOneWidget);
    });
  });

}