import 'package:flutter/material.dart';
import 'package:interactive_book_app/widgets/custom_text_field.dart';
import 'package:interactive_book_app/widgets/read_button.dart';
 

class Selectedbook extends StatefulWidget {
  const Selectedbook({super.key});

  @override
  State<Selectedbook> createState() => SelectedbookState();
}

class SelectedbookState extends State<Selectedbook> {
  String hint = "Search book ";
  List<String> books = ["Biology", "Chemistry", "Math"];
  void searchBooks(String query) {
    if (query.isEmpty) {
      setState(() {
        hint = "Search book ";
      });
      return;
    }
    bool found = books.any(
      (book) => book.toLowerCase().contains(query.toLowerCase()),
    );
    setState(() {
      hint = found ? "Found books!" : "No books found ";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1D0E53),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [CustomTextfield(hinttext:hint,onChanged:searchBooks,)],
        ),
      ),
    );
  }
}
