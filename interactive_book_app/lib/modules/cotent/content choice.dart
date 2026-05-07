import 'dart:convert';

import 'package:flutter/services.dart';

import '../pdf/pdfviewmodel.dart';
import '../video/videoviewmodel.dart';

//class contenthoice{
//   static const List<String> fileNames = [
//     "assets/files/PDFSample3.json",
//     "assets/files/PDFSample2.json",
//     "assets/files/PDFSample.json",
//     "assets/files/SmartObjectSample.json",
//     "assets/files/SmartObjectSample-1.json",
//
//   ];
//
//   static Future<List<String>> getAllTitles() async {
//     List<String> titles = [];
//
//     for (final path in fileNames) {
//       try {
//         final String raw = await rootBundle.loadString(path);
//         final Map<String, dynamic> json = jsonDecode(raw);
//         if (json.containsKey('title')) {
//           titles.add(json['title']);
//         }
//       } catch (e) {
//         print('Error: $e');
//       }
//     }
//
//     return titles;
//   }

class ContentChoice {
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
        print("Error loading $path : $e");
      }
    }

    return titles;
  }

  static Future<dynamic> openContentByTitle(String title) async {
    for (final filepath in fileNames) {
      try {
        String jsonString = await rootBundle.loadString(filepath);
        var jsonData = json.decode(jsonString);

        if (jsonData['title'] == title) {
          String type = jsonData['contentType'];

          if (type == "application/pdf") {
            return await PdfViewModel.loadPdfDetails(title);
          }

          if (type.toString().startsWith("video")) {
            return await videoviewModel.loadvediodetails(title);
          }
        }
      } catch (e) {
        print("Error reading $filepath: $e");
      }
    }

    throw Exception("Content not found");
  }
}
