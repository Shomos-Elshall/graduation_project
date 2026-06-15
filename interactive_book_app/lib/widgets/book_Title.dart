import 'package:flutter/material.dart';

import '../models/book_model.dart';
import '../screens/reading_screen.dart';

class BookTitle extends StatelessWidget {
  final List<BookModel> books;

  const BookTitle({
    super.key,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: books.isEmpty
          ? const Center(
        child: Text(
          "No books found",
          style: TextStyle(fontSize: 18),
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Text(
              "Available Books",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C0054),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: books.length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, index) {
                final book = books[index];

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadingScreen(
                              book: book,
                              sections: book.contents,
                              initialIndex: 0,
                              isArabic: true,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF1D0E53,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                book.title,
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

                    if (index < books.length - 1)
                      const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}