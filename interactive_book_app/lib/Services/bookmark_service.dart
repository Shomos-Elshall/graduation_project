import 'package:hive/hive.dart';
import '../models/toc_model.dart'; // تأكدي من مسار الموديل عندك

class BookmarkService {
  static final _box = Hive.box<TocModel>('bookmarks_box');

  // Toggle bookmark using composite key: {bookId}_{chapterId}
  static void toggleBookmark(String bookId, TocModel chapter) {
    final key = '${bookId}_${chapter.id}';
    if (_box.containsKey(key)) {
      _box.delete(key);
    } else {
      _box.put(key, chapter);
    }
  }

  // Check if chapter is bookmarked for specific book
  static bool isBookmarked(String bookId, int chapterId) {
    final key = '${bookId}_$chapterId';
    return _box.containsKey(key);
  }
}
