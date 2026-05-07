import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interactive_book_app/Services/bookmark_service.dart';

import '../models/toc_model.dart';

class BookMarkButton extends StatelessWidget {
  const BookMarkButton({
    super.key,
    required this.currentChapter,
    required this.bookId,
  });
  final TocModel currentChapter;
  final String bookId;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<TocModel>('bookmarks_box').listenable(),
      builder: (context, Box<TocModel> box, _) {
        final isMarked = BookmarkService.isBookmarked(
          bookId,
          currentChapter.id,
        );
        return IconButton(
          icon: Icon(
            isMarked ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.white,
            size: 28,
          ),
          onPressed:
              () => BookmarkService.toggleBookmark(bookId, currentChapter),
        );
      },
    );
  }
}
