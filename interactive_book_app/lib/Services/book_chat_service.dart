

import 'package:google_generative_ai/google_generative_ai.dart';

class BookChatService {
  late final GenerativeModel _model;
  ChatSession? _chat;

  /// [apiKey] = مفتاح Gemini API بتاعك
  /// [bookContext] = النص الكامل المستخرج من الكتاب (من BookExtractor)
  BookChatService({
    required String apiKey,
    required String bookContext,
    List<Map<String, String>> previousMessages = const [],
  }) {
    final systemInstructionText = '''

You are an intelligent assistant dedicated exclusively to this educational book.
- Answer only from the book content provided below.
- If the question is outside the book's content, clearly state: "This information is not available in the book."
- Do not use any external knowledge or general information unrelated to this book.
- Make your answer accurate and tied to the text, and mention the chapter or section name if possible.

Language rule (most important, never violate it):
- If the user's question is written entirely in English, your answer must be
  entirely in English, without a single Arabic word.
- If the user's question is written in Arabic, answer in Arabic.
- The required language is determined only by the language of the user's latest
  question, regardless of the language of any other instructions here or the
  language of the book content.

Full book content:
$bookContext
''';

    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.text(systemInstructionText),
    );

    // نحول الرسائل القديمة المحفوظة لصيغة يفهمها Gemini، عشان يبدأ
    // المحادثة وهو عارف كل اللي حصل قبل كذا.
    final history = previousMessages.map((msg) {
      final isUser = msg['role'] == 'user';
      return isUser
          ? Content.text(msg['text'] ?? '')
          : Content.model([TextPart(msg['text'] ?? '')]);
    }).toList();

    _chat = _model.startChat(history: history);
  }

  /// يبعت سؤال المستخدم ويرجع رد الموديل.
  /// استخدام startChat() يخلي الموديل يفتكر المحادثة السابقة
  /// من غير الحاجة لإعادة إرسال نص الكتاب كل مرة.
  Future<String> askQuestion(String question) async {
  try {
    final response = await _chat!.sendMessage(Content.text(question));
    return response.text ?? 'حدث خطأ، حاول مرة أخرى.';
  } catch (e) {
    print('GEMINI ERROR: $e');
    return 'حدث خطأ: $e';
  }
}
  /// لو احتجت تبدأ محادثة جديدة (تصفير الـ history) بدون إعادة بناء
  /// الـ context بتاع الكتاب من الأول
  void resetChat() {
    _chat = _model.startChat();
  }
}