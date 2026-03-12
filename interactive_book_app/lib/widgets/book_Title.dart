import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/book_model.dart';

import '../screens/reading_screen.dart';

class BookTitle extends StatefulWidget {
  const BookTitle({super.key});

  @override
  State<BookTitle> createState() => SelectedbookState();
}

class SelectedbookState extends State<BookTitle> {
  String hint = "Search for a book ";

  // هنفتح الـ Box اللي جواه الكتب
  late Box<BookModel> bookBox;

  @override
  void initState() {
    super.initState();
    // بنجيب الـ box اللي فتحناه في الـ main
    bookBox = Hive.box<BookModel>('book');
  }

  @override
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

              return Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Available Books",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1C0054),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // هنا بنروح لصفحة المحتوى وبنبعت الكتاب اللي اخترناه
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookContentPage(book: book!, currentChapter: book.toc.first,),
                        ),
                      );
                      */
                      if (book != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ReadingScreen(
                                  book: book,
                                  sections:
                                      book.contents, // استخدمنا contents زي الموديل بتاعك
                                  initialIndex: 0,
                                  isArabic: true, // القيمة الابتدائية للغة
                                ),
                          ),
                        );
                      }
                      
                    },

                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D0E53).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        // border: Border.all(color: const Color(0xFF1D0E53)),
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

                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFF1D0E53),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
