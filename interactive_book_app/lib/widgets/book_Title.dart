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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Text(
                  "Available Books",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1C0054),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: box.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemBuilder: (context, index) {
                    final book = box.getAt(index);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (book != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ReadingScreen(
                                        book: book,
                                        sections: book.contents,
                                        initialIndex: 0,
                                        isArabic: true,
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
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    book?.title ?? "Unknown Book",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1D0E53),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Color(0xFF1D0E53),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (index < box.length - 1) const SizedBox(height: 8),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
