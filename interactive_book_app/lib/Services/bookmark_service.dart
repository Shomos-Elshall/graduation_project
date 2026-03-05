import 'package:hive/hive.dart';
import '../models/toc_model.dart'; // تأكدي من مسار الموديل عندك

class BookmarkService {
  static final _box = Hive.box<TocModel>('bookmarks_box');

  // وظيفة الإضافة أو الحذف (Toggle)
  static void toggleBookmark(TocModel chapter) {
    // نستخدم ID الشابتر كمفتاح (Key) للتخزين
    if (_box.containsKey(chapter.id.toString())) {
      _box.delete(chapter.id.toString());
    } else {
      _box.put(chapter.id.toString(), chapter);
    }
  }

  // التأكد إذا كان الشابتر محفوظ أم لا لتلوين الأيقونة
  static bool isBookmarked(String id) {
    return _box.containsKey(id);
  }
}