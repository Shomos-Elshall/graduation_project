import 'dart:convert';
import 'package:flutter/services.dart';
import '../video/videoviewmodel.dart';
import 'models/Pdfresponse.dart';

class PdfViewModel {
  static const List<String> fileNames =  videoviewModel.fileNames;
  //   'assets/files/PDFSample.json',
  //   'assets/files/PDFSample2.json',
  //   'assets/files/PDFSample3.json',
  // ];

  static Future<List<String>> getAllTitles() async {
    List<String> titles = [];
    for (final path in fileNames) {
      try {
        final String raw = await rootBundle.loadString(path);
        final Map<String, dynamic> jsonData = jsonDecode(raw);
        if (jsonData.containsKey('title')) {
          titles.add(jsonData['title']);
        }
      } catch (e) {
        print('Error: $e');
      }
    }
    return titles;
  }

  static Future<Pdfresponse> loadPdfDetails(String title) async {
    for (final filepath in fileNames) {
      try {
        String jsonString = await rootBundle.loadString(filepath);
        var jsonData = json.decode(jsonString);
        if (jsonData['title'] == title && jsonData["contentType"]== "application/pdf") {
          return Pdfresponse.fromJson(jsonData);
        }
      } catch (e) {
        print('Error reading $filepath: $e');
      }
    }
    throw Exception("PDF not found");
  }
}
