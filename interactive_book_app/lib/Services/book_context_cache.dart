
// المسؤولية: تخزين النص المستخرج من الكتاب محليًا (Cache) عشان مانعيدش
// استخراج النص من JSON كل مرة المستخدم يفتح الشات أو يسأل سؤال.
//
// لازم تضيف الباكدج دي في pubspec.yaml:
//   shared_preferences: ^2.2.2

import 'package:shared_preferences/shared_preferences.dart';
import 'package:interactive_book_app/models/book_model.dart';
import 'book_extractor.dart';

class BookContextCache {
  /// يرجع نص الكتاب من الكاش لو موجود، ولو مش موجود يستخرجه
  /// من BookModel ويخزنه عشان المرات الجاية.
  ///
  /// [book] = الـ BookModel بتاع الكتاب (نفسه اللي بتستخدمه لعرض الكتاب)
  static Future<String> getOrBuildContext(BookModel book) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'book_context_${book.id}';

    final cached = prefs.getString(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    final context = BookExtractor.buildBookContext(
      bookTitle: book.title,
      contents: book.contents,
    );

    // ملحوظة: لو النص كبير جدًا (أكتر من ~1MB) SharedPreferences ممكن
    // ما يكونش الخيار الأمثل، وقتها استخدم ملف محلي عادي عن طريق
    // package: path_provider بدلاً من SharedPreferences.
    await prefs.setString(cacheKey, context);

    return context;
  }

  /// لمسح الكاش لو احتجت تستخرج النص من جديد (مثلاً بعد تحديث الكتاب)
  static Future<void> clearCache(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('book_context_$bookId');
  }
}