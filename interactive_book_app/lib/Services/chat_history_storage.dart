// ضع هذا الملف في: lib/services/chat_history_storage.dart
//
// المسؤولية: حفظ واسترجاع رسائل المحادثة (سؤال/رد) لكل كتاب على حدة،
// بحيث لما المستخدم يقفل الشات ويرجعله تاني يلاقي المحادثة كما هي.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHistoryStorage {
  static String _keyFor(String bookId) => 'chat_history_$bookId';

  /// يرجع كل الرسائل المحفوظة لكتاب معين.
  /// كل رسالة عبارة عن Map فيها 'role' (user أو bot) و 'text'.
  /// لو مفيش محادثة محفوظة قبل كذا، يرجع List فاضية.
  static Future<List<Map<String, String>>> loadMessages(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFor(bookId));

    if (raw == null || raw.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Map<String, String>.from(item as Map))
        .toList();
  }

  /// يحفظ كل قائمة الرسائل الحالية لكتاب معين (يستبدل القديم بالكامل).
  /// بننادي على الدالة دي بعد كل رسالة جديدة (سؤال أو رد) عشان نضمن
  /// إن أي رسالة جديدة تتخزن فورًا.
  static Future<void> saveMessages(
    String bookId,
    List<Map<String, String>> messages,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(messages);
    await prefs.setString(_keyFor(bookId), encoded);
  }

  /// يمسح المحادثة بالكامل لكتاب معين (لو احتجت زرار "محادثة جديدة" مثلاً)
  static Future<void> clearMessages(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFor(bookId));
  }
}