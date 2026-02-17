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
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // register adapters
  Hive.registerAdapter(BookModelAdapter());
  Hive.registerAdapter(TocModelAdapter());
  Hive.registerAdapter(ContentModelAdapter());
  Hive.registerAdapter(GlossaryModelAdapter());
  Hive.registerAdapter(BookObjectsAdapter());
  Hive.registerAdapter(KeywordModelAdapter());

  // open boxes
  await Hive.openBox<BookModel>(bookBox);
  await Hive.openBox(tocBox);
  await Hive.openBox(contentBox);
  await Hive.openBox(glossaryBox);
  await Hive.openBox(book_objectBox);
  await Hive.openBox(keywordsBox);

  runApp(const InteractiveBookApp());
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

    print("book title : ${book.title}");

    for (var item in book.toc) {
      print("TOC name: ${item.name}  and its text: ${item.text?.en}");
    }

    // storing data in hive
    final box = Hive.box<BookModel>(bookBox);
    await box.put('book1', book);

    // reading data from hive

    final bookFromHive = box.get("book1");
    print(" book title from hive: ${bookFromHive?.title}");
    print("book id : ${bookFromHive?.id}");

    print("from hive: ");
    if (bookFromHive != null) {
      for (var item in bookFromHive.toc) {
        print(item.name);
      }
    }
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
