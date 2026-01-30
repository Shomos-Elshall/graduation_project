import 'package:flutter/material.dart';
import 'package:interactive_book_app/widgets/ReadButton.dart';
import 'package:interactive_book_app/widgets/app_bar.dart';
import 'package:interactive_book_app/widgets/dropdown.dart';

class Selectedbook extends StatefulWidget {
  const Selectedbook({super.key});

  @override
  State<Selectedbook> createState() => SelectedbookState();
}

class SelectedbookState extends State<Selectedbook> {
  String? selectedBook;
  List<String> books = ["Biology", "Chemistry", "Math"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
             DropDownButton(),
             ReadButton(selectedBook: selectedBook),
  





          ],
        ),
      ),
    );
  }
}
