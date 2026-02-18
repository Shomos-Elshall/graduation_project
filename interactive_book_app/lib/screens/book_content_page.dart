import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/book_model.dart';

class BookContentPage extends StatelessWidget {
  final BookModel book;

  const BookContentPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(book.title,
          style: TextStyle(color: Colors.white),), // اسم الكتاب اللي اخترناه
          backgroundColor: const Color(0xFF1D0E53),
        )
    );
  }
    }