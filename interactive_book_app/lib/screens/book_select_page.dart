// import 'package:flutter/material.dart';
// import 'package:interactive_book_app/widgets/custom_text_field.dart';
//
// class Selectedbook extends StatefulWidget {
//   const Selectedbook({super.key});
//
//   @override
//   State<Selectedbook> createState() => SelectedbookState();
// }
//
// class SelectedbookState extends State<Selectedbook> {
//   String hint = "Search book ";
//   List<String> books = ["Biology", "Chemistry", "Math"];
//   void searchBooks(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         hint = "Search book ";
//       });
//       return;
//     }
//     bool found = books.any(
//       (book) => book.toLowerCase().contains(query.toLowerCase()),
//     );
//     setState(() {
//       hint = found ? "Found books!" : "No books found ";
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF1D0E53),
//         title: Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: Image.asset(
//             "assets/images/image 1 (1).png",
//             width: 170,
//             height: 130,
//           ),
//         ),
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [CustomTextfield(hinttext: hint, onChanged: searchBooks)],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // مهم جداً للـ ValueListenableBuilder
import 'package:interactive_book_app/models/book_model.dart'; // تأكدي من مسار الموديل
import 'package:interactive_book_app/widgets/custom_text_field.dart';

import '../widgets/book_Title.dart';
import 'book_content_page.dart';
// import 'package:interactive_book_app/pages/book_content_page.dart'; // صفحة المحتوى (افترضي اسمها كده)

class Selectedbook extends StatefulWidget {
  const Selectedbook({super.key});

  @override
  State<Selectedbook> createState() => SelectedbookState();
}

class SelectedbookState extends State<Selectedbook> {
  String hint = "Search book ";



  @override


  void searchBooks(String query) {
    // منطق البحث (ممكن نفلتر الـ list هنا لو حابة)
    setState(() {
      hint = query.isEmpty ? "Search book " : "Searching...";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            CustomTextfield(hinttext: hint, onChanged: searchBooks),
            const SizedBox(height: 20),

            // الجزء الخاص بعرض الكتب من Hive
            book_title(),

          ],
        ),
      ),
    );
  }
}