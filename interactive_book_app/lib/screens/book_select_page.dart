import 'package:flutter/material.dart';
import 'package:interactive_book_app/widgets/custom_text_field.dart';

import '../widgets/book_title.dart';

// import 'package:interactive_book_app/pages/book_content_page.dart'; // صفحة المحتوى (افترضي اسمها كده)

class Selectedbook extends StatefulWidget {
  const Selectedbook({super.key});

  @override
  State<Selectedbook> createState() => SelectedbookState();
}

class SelectedbookState extends State<Selectedbook> {
  String hint = "Search for a book";

  void searchBooks(String query) {
    // منطق البحث (ممكن نفلتر الـ list هنا لو حابة)
    setState(() {
      hint = query.isEmpty ? "Search book " : "Searching...";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D0E53),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Image.asset(
            "assets/images/image 1 (1).png",
            width: 170,
            height: 130,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextfield(hintText: hint, onChanged: searchBooks),
            const SizedBox(height: 20),

            // الجزء الخاص بعرض الكتب من Hive
            BookTitle(),
          ],
        ),
      ),
    );
  }
}
