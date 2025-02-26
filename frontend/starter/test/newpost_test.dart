import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter/api_service.dart';

void main() {
  final int last_post = 4;

  setUpAll(() async {
    // Load the environment variables for testing
    await dotenv.load(fileName: ".env");
  });

  group('New Post Tests:', () {
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

      await ApiService.deleteJobListing(last_post); 
    });

    test('Job listing post with incomplete details returns 422', () async {

      final Map<String, dynamic> newPostDetails = {
        'tag': ['Education'],   
        'job_title': null, 
        'description': 'Job listing to be listed in the job listing page',
        'location': 'Makati City',
        'salary': 10,           
        'salary_frequency': 'Hourly',  
        'duration': 'Short-term'   
      };

      final response = await ApiService.postJobListing(newPostDetails);

      expect(response.statusCode, 422); 

      await ApiService.deleteJobListing(last_post); 
    });

    test('Verify deletion of posted job listing', () async {

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

      await ApiService.postJobListing(newPostDetails);

      final response = await ApiService.deleteJobListing(last_post);  

      final responseBody = jsonDecode(response.body);
      expect(responseBody['message'], 'Job listing deleted successfully');
    });
  });
}
