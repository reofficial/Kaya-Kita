import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/profile_provider.dart';
import 'api_service.dart';

class LogService {
  static Future<void> postLog(String logContent,
      {required BuildContext context}) async {
    try {
      final username =
          Provider.of<UserProvider>(context, listen: false).username;

      final response = await ApiService.createLog(
        officialUsername: username,
        log: logContent,
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to post log. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> postLogWithUsername({
    required String username,
    required String logContent,
  }) async {
    try {
      final response = await ApiService.createLog(
        officialUsername: username,
        log: logContent,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
            'Failed to post log. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
