import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'mock_api_service.dart';

void main() {
  
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

      final response = await MockApiService.postJobListing(newPostDetails);

      expect(response.statusCode, 201);
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

      final response = await MockApiService.postJobListing(newPostDetails);

      expect(response.statusCode, 422); 
    });

    test('Verify deletion of posted job listing', () async {

      final response = await MockApiService.deleteJobListing(2);  

      final responseBody = jsonDecode(response.body);
      expect(responseBody['message'], 'Job listing deleted successfully');
    });

    test('Delete nonexistent job listing returns 404', () async {

      final response = await MockApiService.deleteJobListing(4);  

      expect(response.statusCode, 404);

      final responseBody = jsonDecode(response.body);
      expect(responseBody['detail'], 'Job listing not found');
    });
    
  });
}
