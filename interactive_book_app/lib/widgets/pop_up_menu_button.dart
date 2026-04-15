import 'package:flutter/material.dart';
import 'package:interactive_book_app/models/book_model.dart';
import 'package:interactive_book_app/modules/cotent/titlepage.dart';
import 'package:interactive_book_app/screens/book_marks_screen.dart';
import 'package:interactive_book_app/screens/book_objects_screen.dart';
import 'package:interactive_book_app/screens/glossary_screen.dart';

class PopUpMenuButton extends StatelessWidget {
  const PopUpMenuButton({super.key, required this.book});

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      iconSize: 32,
      color: Colors.white,
      menuPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      borderRadius: BorderRadius.circular(64),
      onSelected: (value) {
        if (value == 'Glossary') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GlossaryScreen(glossaryList: book.glossary),
            ),
          );
        } else if (value == "Bookmarks") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookmarksScreen(book: book),
            ),
          );
        } else if (value == "Objects") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TitlePage()),
          );
        }
      },

      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: "Glossary",
            child: Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  color: Color(0xFF1A0054),
                  size: 29,
                ),
                SizedBox(width: 16),
                Text(
                  "Glossary",
                  style: TextStyle(
                    color: Color(0xFF1A0054),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),

          PopupMenuItem<String>(
            value: "Bookmarks",
            child: Row(
              children: [
                Icon(
                  Icons.bookmark_outline,
                  color: Color(0xFF1A0054),
                  size: 29,
                ),
                SizedBox(width: 16),
                Text(
                  "Bookmarks",
                  style: TextStyle(
                    color: Color(0xFF1A0054),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: "Objects",
            child: Row(
              children: [
                Icon(
                  Icons.extension_outlined,
                  color: Color(0xFF1A0054),
                  size: 29,
                ),
                SizedBox(width: 16),
                Text(
                  "Objects",
                  style: TextStyle(
                    color: Color(0xFF1A0054),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}
