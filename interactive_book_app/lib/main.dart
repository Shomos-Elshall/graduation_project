import 'package:flutter/material.dart';
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

  await Hive.openBox(bookBox);
  Hive.registerAdapter(BookModelAdapter());
  await Hive.openBox(tocBox);
  Hive.registerAdapter(TocModelAdapter());
  await Hive.openBox(contentBox);
  Hive.registerAdapter(ContentModelAdapter());
  await Hive.openBox(glossaryBox);
  Hive.registerAdapter(GlossaryModelAdapter());
  await Hive.openBox(book_objectBox);
  Hive.registerAdapter(bookobjectsAdapter());
  await Hive.openBox(keywordsBox);
  Hive.registerAdapter(KeywordModelAdapter());

}

class InteractiveBookApp extends StatelessWidget {
  const InteractiveBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Selectedbook());
  }
}
