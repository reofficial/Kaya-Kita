import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter/api_service.dart';

void main() {
  setUpAll(() async {
    // Load the environment variables for testing
    await dotenv.load(fileName: ".env");
  });

  group('New Post Tests: ', () {
    test('Valid job listing post returns 200', () async {

      final Map<String, dynamic> newPostDetails = {
        'username': 'testuser',
        'tag': ['Education'], 
        'job_title': 'Job Listing Header test',        
        'description': 'Job listing to be listed in the job listing page',
        'location': 'Makati City',
        'salary': 10,           
        'salary_frequency': 'Hourly',  
        'duration': 'Short-term'   
      };

      final response = await ApiService.postJobListing(newPostDetails);

      expect(response.statusCode, 201);

      await ApiService.deleteJobListing(4); 
    });

    // test('Valid job listing post returns 200', () async {

    //   final Map<String, dynamic> newPostDetails = {
    //     'tag': ['Education'],    
    //     'description': 'Job listing to be listed in the job listing page',
    //     'location': 'Makati City',
    //     'salary': 10,           
    //     'salary_frequency': 'Hourly',  
    //     'duration': 'Short-term'   
    //   };

    //   final response = await ApiService.postJobListing(newPostDetails);

    //   expect(response.statusCode, 400); 
    // });
  });
}
