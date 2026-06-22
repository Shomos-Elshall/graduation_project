

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

أنت مساعد ذكي مخصص لهذا الكتاب التعليمي فقط.
- أجب فقط من محتوى الكتاب المرفق أدناه.
- إذا كان السؤال خارج محتوى الكتاب، قل بوضوح: "هذه المعلومة غير موجودة في الكتاب."
- لا تستخدم أي معرفة خارجية أو معلومات عامة لا تخص هذا الكتاب.
- اجعل إجابتك دقيقة ومرتبطة بالنص، واذكر اسم الفصل أو القسم إن أمكن.
 
قاعدة اللغة (الأهم، لا تخالفها أبدًا):
- إذا كان سؤال المستخدم مكتوبًا بالإنجليزية بالكامل، يجب أن تكون إجابتك
  بالإنجليزية بالكامل، بدون أي كلمة عربية واحدة.
- إذا كان سؤال المستخدم مكتوبًا بالعربية، أجب بالعربية.
- اللغة المطلوبة تحددها فقط لغة آخر سؤال من المستخدم، بصرف النظر عن
  لغة أي تعليمات أخرى هنا أو لغة محتوى الكتاب.
 
محتوى الكتاب الكامل:
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
    final response = await _chat!.sendMessage(Content.text(question));
    return response.text ?? 'حدث خطأ، حاول مرة أخرى.';
  }

  /// لو احتجت تبدأ محادثة جديدة (تصفير الـ history) بدون إعادة بناء
  /// الـ context بتاع الكتاب من الأول
  void resetChat() {
    _chat = _model.startChat();
  }
}