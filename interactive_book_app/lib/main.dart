import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interactive_book_app/models/book_model.dart';
import 'package:interactive_book_app/models/content_model.dart';
import 'package:interactive_book_app/screens/book_select_page.dart';

void main() async {
  runApp(const InteractiveBookApp());
  await Hive.initFlutter();
}

class InteractiveBookApp extends StatelessWidget {
  const InteractiveBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Selectedbook());
  }
}
