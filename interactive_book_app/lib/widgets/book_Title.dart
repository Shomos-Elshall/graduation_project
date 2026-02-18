import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants.dart';
import '../models/book_model.dart';
import '../screens/book_content_page.dart';

class book_title extends StatefulWidget {
  const book_title({super.key});

  @override
  State<book_title> createState() => SelectedbookState();
}

class SelectedbookState extends State<book_title> {
  String hint = "Search book ";

  // هنفتح الـ Box اللي جواه الكتب
  late Box<BookModel> bookBox;

  @override
  void initState() {
    super.initState();
    // بنجيب الـ box اللي فتحناه في الـ main
    bookBox = Hive.box<BookModel>('book');
  }

  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: bookBox.listenable(),
        builder: (context, Box<BookModel> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No books available"));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final book = box.getAt(index);

              return GestureDetector(
                onTap: () {
                  // هنا بنروح لصفحة المحتوى وبنبعت الكتاب اللي اخترناه
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BookContentPage(book: book!)));
                  print("Tapped on ${book?.title}");
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D0E53).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1D0E53)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        book?.title ?? "Unknown Book",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D0E53),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF1D0E53)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );

  }
}
