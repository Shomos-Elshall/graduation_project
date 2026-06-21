
// المسؤولية: يحول بيانات الكتاب (BookModel.contents) إلى نص عادي
// (plain text) جاهز إنه يتبعت للـ Gemini كـ context.
//
// ملحوظة مهمة: contents في BookModel هي List مسطحة (flat list) من
// ContentModel، كل عنصر فيها عنده depth (مستوى العنوان) و parentId
// (بيشير لإيه العنصر اللي قبله في الهيكل). إحنا هنا مش محتاجين نبني
// شجرة فعلية، يكفي إننا نمشي على الـ list بالترتيب ونستخدم depth
// لتحديد حجم العنوان (## أو ### ... إلخ).

import 'package:html/parser.dart' show parse;
import 'package:interactive_book_app/models/content_model.dart';

class BookExtractor {
  /// يحول أي HTML string لنص عادي بدون tags
  static String stripHtml(String html) {
    final document = parse(html);
    return document.body?.text.trim() ?? '';
  }

  /// يمشي على القائمة المسطحة لـ ContentModel بالترتيب، ويجمع كل
  /// النصوص مع عناوين الأقسام، مستخدمًا depth لتحديد مستوى العنوان.
  static String extractText(List<ContentModel> contents) {
    final buffer = StringBuffer();

    for (final item in contents) {
      final name = item.name.trim();
      final text = item.textEn; // ممكن تستخدم textAr لو عايز اللغة العربية

      if (name.isNotEmpty) {
        // depth بيبدأ من 0 عادة، فبنضيف 1 عشان أقل عنوان يكون ##
        final headingLevel = (item.depth + 1).clamp(1, 6);
        buffer.writeln('${'#' * headingLevel} $name');
      }

      if (text != null && text.trim().isNotEmpty) {
        buffer.writeln(stripHtml(text));
        buffer.writeln();
      }
    }

    return buffer.toString();
  }

  /// نقطة الدخول الرئيسية: تاخد BookModel.contents وترجع نص واحد
  /// يحتوي على عنوان الكتاب + كل الفصول والأقسام بدون أي HTML tags.
  static String buildBookContext({
    required String bookTitle,
    required List<ContentModel> contents,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('Book Title: $bookTitle');
    buffer.writeln();
    buffer.write(extractText(contents));

    return buffer.toString();
  }

  /// أداة مساعدة لتقدير عدد الـ tokens تقريبيًا (1 token ≈ 4 حروف بالإنجليزي)
  /// تستخدمها للتأكد إن النص يدخل في حدود الموديل قبل إرساله.
  static int estimateTokens(String text) => (text.length / 4).ceil();
}