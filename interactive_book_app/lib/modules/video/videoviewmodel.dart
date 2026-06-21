import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:interactive_book_app/models/module_video_ref.dart';
import 'package:interactive_book_app/modules/video/models/Videoresponse.dart';

class videoviewModel {
  static const List<String> fileNames = [
    "assets/files/PDFSample3.json",
    "assets/files/PDFSample2.json",
    "assets/files/PDFSample.json",
    "assets/files/SmartObjectSample.json",
    "assets/files/SmartObjectSample-1.json",
  ];

  static Future<List<String>> getAllTitles() async {
    List<String> titles = [];

    for (final path in fileNames) {
      try {
        final String raw = await rootBundle.loadString(path);
        final Map<String, dynamic> json = jsonDecode(raw);
        if (json.containsKey('title')) {
          titles.add(json['title']);
        }
      } catch (e) {
        print('Error: $e');
      }
    }

    return titles;
  }

  static Future<Videoresponse> loadvediodetails(String title) async {
    for (final filepath in fileNames) {
      String jsonString = await rootBundle.loadString(filepath);
      var jsonData = json.decode(jsonString);

      if (jsonData['title'] == title &&
          jsonData["contentType"] == "video/mp4") {
        return Videoresponse.fromJson(jsonData);
      }
    }

    throw Exception("Video not found");
  }

  static Future<Videoresponse> loadFromRef(ModuleVideoRef ref) async {
    if (ref.source == 'inline') {
      final payload = ref.payload;
      if (payload == null) {
        throw Exception("ModuleVideoRef.inline without payload");
      }
      return Videoresponse.fromJson(payload);
    }

    final path = ref.path;
    if (path == null) {
      throw Exception("ModuleVideoRef.asset without path");
    }
    final String jsonString = await rootBundle.loadString(path);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    return Videoresponse.fromJson(jsonData);
  }
}



// static Future<Videoresponse> loadvediodetails() async {
//    String filepath="assets/files/SmartObjectSample.json";
//   String jsonString = await rootBundle.loadString(filepath);
//   var jsonData = json.decode(jsonString);
//   return Videoresponse.fromJson(jsonData);
// }