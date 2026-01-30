import 'package:flutter/material.dart';
import 'package:interactive_book_app/screens/SelectedBook.dart';
import 'package:interactive_book_app/widgets/app_bar.dart';

void main() {
  runApp(const InteractiveBookApp());
}

class InteractiveBookApp extends StatelessWidget {
  const InteractiveBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Selectedbook());
  }
}
