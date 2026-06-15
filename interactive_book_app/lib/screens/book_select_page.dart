import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/book_model.dart';
import '../widgets/book_title.dart';
import '../widgets/custom_text_field.dart';

class Selectedbook extends StatefulWidget {
  const Selectedbook({super.key});

  @override
  State<Selectedbook> createState() => _SelectedbookState();
}

class _SelectedbookState extends State<Selectedbook> {
  late Box<BookModel> bookBox;

  List<BookModel> allBooks = [];
  List<BookModel> filteredBooks = [];

  @override
  void initState() {
    super.initState();

    bookBox = Hive.box<BookModel>('book');

    allBooks = bookBox.values.toList();
    filteredBooks = allBooks;

    bookBox.listenable().addListener(_refreshBooks);
  }

  void _refreshBooks() {
    setState(() {
      allBooks = bookBox.values.toList();
      filteredBooks = allBooks;
    });
  }

  @override
  void dispose() {
    bookBox.listenable().removeListener(_refreshBooks);
    super.dispose();
  }

  void searchBooks(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        filteredBooks = allBooks;
      } else {
        filteredBooks = allBooks.where((book) {
          return book.title.toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();
      }
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
            CustomTextfield(
              hintText: "Search for a book",
              onChanged: searchBooks,
            ),

            const SizedBox(height: 20),

            BookTitle(
              books: filteredBooks,
            ),
          ],
        ),
      ),
    );
  }
}