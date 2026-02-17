import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interactive_book_app/constants.dart';
import 'package:interactive_book_app/screens/book_select_page.dart';
import 'models/book_model.dart';
import 'models/book_objects_model.dart';
import 'models/content_model.dart';
import 'models/glossary_model.dart';
import 'models/keyword_model.dart';
import 'models/toc_model.dart';

void main() async {
  runApp(const InteractiveBookApp());
  await Hive.initFlutter();

  //book box
  Hive.registerAdapter(BookModelAdapter());
  await Hive.openBox(bookBox);

  // TOC box
  Hive.registerAdapter(TocModelAdapter());
  await Hive.openBox(tocBox);

  //content box
  Hive.registerAdapter(ContentModelAdapter());
  await Hive.openBox(contentBox);

  //Glossary box
  Hive.registerAdapter(GlossaryModelAdapter());
  await Hive.openBox(glossaryBox);

  //bookObject box
  Hive.registerAdapter(BookObjectsAdapter());
  await Hive.openBox(book_objectBox);

  // keywords box
  Hive.registerAdapter(KeywordModelAdapter());
  await Hive.openBox(keywordsBox);
}

class InteractiveBookApp extends StatelessWidget {
  const InteractiveBookApp({super.key});

  Future<String> loadJsonData() async {
    return await rootBundle.loadString('assets/data/data.json');
  }

  Future<void> loadDataIntoHive() async {
    final String jsonData = await loadJsonData();
    var data = jsonDecode(jsonData);
    BookModel book = BookModel.fromJson(data);

    print(book.title);
  }

  @override
  Widget build(BuildContext context) {
    loadDataIntoHive();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Selectedbook(),
    );
  }
}
