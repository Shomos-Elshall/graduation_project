import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
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
}



// static Future<Videoresponse> loadvediodetails() async {
//    String filepath="assets/files/SmartObjectSample.json";
//   String jsonString = await rootBundle.loadString(filepath);
//   var jsonData = json.decode(jsonString);
//   return Videoresponse.fromJson(jsonData);
// }