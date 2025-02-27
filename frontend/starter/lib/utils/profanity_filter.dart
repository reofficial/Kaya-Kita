import 'package:flutter/services.dart';

/// Loads the list of profanity patterns from `assets/badwords.txt`.
Future<List<RegExp>> loadProfanityPatterns() async {
  try {
    // Load the file from the assets
    String fileContents = await rootBundle.loadString('assets/badwords.txt');
    // Split the file contents into lines and trim any whitespace
    List<String> lines =
        fileContents.split('\n').map((line) => line.trim()).toList();
    // Remove any empty lines
    lines.removeWhere((line) => line.isEmpty);
    // Compile each line into a RegExp object
    List<RegExp> patterns =
        lines.map((line) => RegExp(line, caseSensitive: false)).toList();
    return patterns;
  } catch (e) {
    return []; // Return an empty list if there's an error
  }
}

bool containsProfanity(String text, List<RegExp> profanityPatterns) {
  return profanityPatterns.any((pattern) => pattern.hasMatch(text));
}