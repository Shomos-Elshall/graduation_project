import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/bookmark_service.dart';
import '../models/toc_model.dart';

class BookMarkButton extends StatelessWidget {
  const BookMarkButton({super.key, required this.currentChapter});
  final TocModel currentChapter;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<TocModel>('bookmarks_box').listenable(),
      builder: (context, Box<TocModel> box, _) {
        final isMarked = box.containsKey(currentChapter.id.toString());
        return IconButton(
          icon: Icon(
            isMarked ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () => BookmarkService.toggleBookmark(currentChapter),
        );
      },
    );
  }
}
