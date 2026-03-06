import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/book_model.dart';
import '../models/toc_model.dart';
import 'book_content_page.dart';

class BookmarksScreen extends StatelessWidget {
  final BookModel book;

  const BookmarksScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // لون خلفية فاتح عشان الـ Cards تبرز
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0054),
        elevation: 0,
        title: const Text(
          "Saved chapters",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 24),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<TocModel>('bookmarks_box').listenable(),
        builder: (context, Box<TocModel> box, _) {
          final bookmarkedChapters = box.values.toList();

          if (bookmarkedChapters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border_rounded,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "The bookmark list is empty",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            itemCount: bookmarkedChapters.length,
            itemBuilder: (context, index) {
              final chapter = bookmarkedChapters[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Card(
                  color: Color(0xffF5F7FA),
                  elevation: 3,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BookContentPage(
                                book: book,
                                currentChapter: chapter,
                              ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // أيقونة الكتاب داخل دائرة ملونة
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A0054).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: Color(0xFF1A0054),
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // اسم الشابتر والوصف
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chapter.name,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A0054),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.touch_app_outlined,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Click to continue reading",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // زر الحذف
                          IconButton(
                            icon: const Icon(
                              Icons.bookmark_remove,
                              color: Color(0xff1C0054),
                              size: 28,
                            ),
                            onPressed: () {
                              box.delete(chapter.id.toString());
                            },
                          ),
                        ],
                      ),
                    ),
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
