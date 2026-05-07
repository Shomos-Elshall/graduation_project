import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interactive_book_app/constants.dart';
import 'package:interactive_book_app/models/book_model.dart';

/// خدمة إدارة الكتب
/// توفر وظائف لتحميل وإدارة الكتب المتعددة
class BookService {
  // قائمة مركزية لملفات الكتب المتاحة
  // يمكن تعديلها وإضافة كتب جديدة بسهولة
  static final List<Map<String, String>> availableBooks = [
    {'path': 'assets/data/data_copy.json', 'key': 'book1'},
    {'path': 'assets/data/data.json', 'key': 'book2'},
    {'path': 'assets/data/book3.json', 'key': 'book3'},
    
  ];

  /// تحميل ملف JSON واحد
  static Future<String> _loadJsonFile(String assetPath) async {
    return await rootBundle.loadString(assetPath);
  }

  /// تحميل كتاب واحد وحفظه في Hive
  static Future<bool> _loadSingleBook(String jsonPath, String bookKey) async {
    try {
      final String jsonData = await _loadJsonFile(jsonPath);
      var data = jsonDecode(jsonData);
      BookModel book = BookModel.fromJson(data);

      final box = Hive.box<BookModel>(bookBox);
      await box.put(bookKey, book);

     
      return true;
    } catch (e) {
      
      return false;
    }
  }

  /// تحميل جميع الكتب المتاحة إلى Hive
  static Future<void> loadAllBooks() async {
    final box = Hive.box<BookModel>(bookBox);
    await box.clear();

    for (var bookFile in availableBooks) {
      await _loadSingleBook(bookFile['path']!, bookFile['key']!);
    }

    
  }

  /// الحصول على جميع الكتب
  static List<BookModel> getAllBooks() {
    final box = Hive.box<BookModel>(bookBox);
    return box.values.toList();
  }

  /// الحصول على كتاب محدد برقم المفتاح
  static BookModel? getBookByKey(String key) {
    final box = Hive.box<BookModel>(bookBox);
    return box.get(key);
  }

  /// الحصول على عدد الكتب المحملة
  static int getBookCount() {
    final box = Hive.box<BookModel>(bookBox);
    return box.length;
  }

  /// إضافة كتاب جديد من ملف JSON
  static Future<bool> addNewBook(String assetPath, String bookKey) async {
    return await _loadSingleBook(assetPath, bookKey);
  }
}
