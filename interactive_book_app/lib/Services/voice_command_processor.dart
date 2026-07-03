import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/voice_command_result.dart';

class VoiceCommandProcessor {

  /// يفحص الأوامر محلياً أولاً لحل مشكلة اللغات، وإذا كان سؤالاً علمياً يرسله لـ Gemini
  static Future<VoiceCommandResult> process({
    required String spokenText,
    required List<String> chapterNames,
    required String fullBookContext,
  }) async {
    final cleanText = spokenText.toLowerCase().trim();

    // 1. الفحص الفوري للأوامر المحلية لضمان السرعة الفائقة بدون تأخير نت
    if (cleanText.contains('read') || cleanText.contains('ريد') || cleanText.contains('ريت') || cleanText.contains('انجلش') || cleanText.contains('read this chapter')) {
      return VoiceCommandResult(action: VoiceAction.read, answer: 'en'); // إجبار نطق إنجليزي
    }

    if (cleanText.contains('اقرأ') || cleanText.contains('اقرا') || cleanText.contains('أقرأ') || cleanText.contains('قراءة')) {
      if (!cleanText.contains('روح') && !cleanText.contains('افتح') && !cleanText.contains('شابتر') && !cleanText.contains('chapter') && !cleanText.contains('اذهب')) {
        return VoiceCommandResult(action: VoiceAction.read, answer: 'ar'); // إجبار نطق عربي
      }
    }

    // 🛠️ تم تصحيح next_chapter إلى مسافة عادية وإزالة المسافات الزائدة في آخر السطور
    if (cleanText.contains('التالي') || cleanText.contains('next') || cleanText.contains('نكست') || cleanText.contains('بعده') || cleanText.contains('go to next chapter') || cleanText.contains('next chapter') || cleanText.contains('روح للشابتر اللي بعده') || cleanText.contains('اقلب الشابتر')) {
      return VoiceCommandResult(action: VoiceAction.next);
    }

    // 🛠️ تم إزالة المسافة الزائدة في آخر الجملة هنا لتطابق الـ trim
    if (cleanText.contains('السابق') || cleanText.contains('back') || cleanText.contains('باك') || cleanText.contains('ارجع') || cleanText.contains('ارجع للشابتر اللي قبل ده') || cleanText.contains('back to previous chapter')) {
      return VoiceCommandResult(action: VoiceAction.previous);
    }

    // قاموس الفحص المحلي الذكي للتنقل المباشر والمركب
    String? localTarget;
    bool readAfter = cleanText.contains('واقرأ') || cleanText.contains('واقرا') || cleanText.contains('واقرأه') || cleanText.contains('واقراه') || cleanText.contains('read');

    // 🛠️ تم تنظيف كافة الجمل الإنجليزية والعربية من المسافات الختامية ودعم كلمة chapter ديناميكياً
    if (cleanText.contains('مقدمة') || cleanText.contains('روح للمقدمة') || cleanText.contains('اذهب للمقدمة') || cleanText.contains('introduction') || cleanText.contains('go to introduction') || cleanText.contains('chapter introduction')) {
      localTarget = 'Introduction';
    } else if (cleanText.contains('ما هو التنفس') || cleanText.contains('what is respiration') || cleanText.contains('go to what is respiration') || cleanText.contains('chapter respiration')) {
      localTarget = 'What is respiration ?';
    } else if (cleanText.contains('لماذا التنفس') || cleanText.contains('why respiration') || cleanText.contains('go to why respiration') || cleanText.contains('chapter why respiration')) {
      localTarget = 'why respiration';
    } else if (cleanText.contains('التنفس الخلوي') || cleanText.contains('خلوي') || cleanText.contains('cellular respiration') || cleanText.contains('go to cellular respiration') || cleanText.contains('chapter cellular respiration')) {
      localTarget = 'cellular respiration';
    } else if (cleanText.contains('الهوائي') || cleanText.contains('aeropic') || cleanText.contains('aerobic') || cleanText.contains('go to aerobic') || cleanText.contains('go to aerobic respiration')) {
      localTarget = 'aeropic respiration';
    } else if (cleanText.contains('أكسدة') || cleanText.contains('اكسدة') || cleanText.contains('oxidization') || cleanText.contains('go to oxidization') || cleanText.contains('glucose oxidization')) { // 🛠️ تم تصحيح go ot إلى go to
      localTarget = 'Glucose oxidization stages';
    } else if (cleanText.contains('تحلل السكر') || cleanText.contains('تحلل سكر') || cleanText.contains('glycolysis') || cleanText.contains('go to glycolysis') || cleanText.contains('chapter glycolysis')) {
      localTarget = 'Glycolysis';
    } else if (cleanText.contains('كريبس') || cleanText.contains('krebs') || cleanText.contains('go to krebs') || cleanText.contains('chapter krebs') || cleanText.contains('krebs cycle')) {
      localTarget = 'Krebs cycle';
    } else if (cleanText.contains('نقل الإلكترون') || cleanText.contains('نقل الالكترون') || cleanText.contains('electron transport') || cleanText.contains('go to electron transport') || cleanText.contains('chapter electron transport')) { // 🛠️ تم تصحيح electron_transport إلى مسافة عادية
      localTarget = 'Electron transport';
    } else if (cleanText.contains('اللاهوائي') || cleanText.contains('لاهوائي') || cleanText.contains('anaerobic') || cleanText.contains('go to anaerobic') || cleanText.contains('chapter anaerobic')) {
      localTarget = 'anaeropic respiration';
    } else if (cleanText.contains('الإنسان') || cleanText.contains('انسان') || cleanText.contains('human') || cleanText.contains('go to human') || cleanText.contains('chapter human')) {
      localTarget = 'Respiration in human';
    } else if (cleanText.contains('الكائنات الحية') || cleanText.contains('الكائنات الحيه') || cleanText.contains('living organisms') || cleanText.contains('go to living organisms') || cleanText.contains('chapter living organisms')) {
      localTarget = 'Respiration in living organisms';
    }

    if (localTarget != null) {
      return VoiceCommandResult(action: VoiceAction.navigate, target: localTarget, readAfterNavigate: readAfter);
    }

    // 2. إذا لم يكن أمراً صريحاً، فإنه سؤال علمي عن محتوى الكتاب يتم إرساله لـ Gemini وإصلاح استجابته
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY']!;

      final systemInstruction = '''
You are an expert voice assistant for an educational textbook. Your job is to answer questions or interpret navigation commands.
You MUST return a clean JSON object ONLY. No markdown, no extra text.

JSON Format:
{
  "action": "CHAT" or "NAVIGATE",
  "target": "Exact chapter name from the list if action is NAVIGATE",
  "read_after_navigate": true or false,
  "answer": "If action is CHAT, answer the user's scientific question concisely and beautifully based ONLY on the provided Book Context. Match the user's language: if they ask in Arabic, answer in Arabic. If they ask in English, answer in English."
}

Available Chapters List:
$chapterNames

Book Context:
$fullBookContext
''';

      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
        systemInstruction: Content.text(systemInstruction),
      );

      final response = await model.generateContent([Content.text("User input is: \"$spokenText\"")]);
      final responseText = response.text;

      if (responseText != null) {
        String extractedJson = responseText.trim();
        // تنظيف وحماية الجيسون من أي نصوص زائدة
        if (extractedJson.contains('{') && extractedJson.contains('}')) {
          extractedJson = extractedJson.substring(extractedJson.indexOf('{'), extractedJson.lastIndexOf('}') + 1);
        }

        final Map<String, dynamic> data = jsonDecode(extractedJson);
        final String actStr = data['action'] ?? 'CHAT';

        VoiceAction finalAction = VoiceAction.chat;
        if (actStr == 'NAVIGATE') finalAction = VoiceAction.navigate;

        // تنظيف نص الإجابة من أي علامات نجوم (*) أو رموز مارك داون قبل إعطائها للنطق
        String? cleanAnswer = data['answer'];
        if (cleanAnswer != null) {
          cleanAnswer = cleanAnswer.replaceAll('*', '').replaceAll('#', '').trim();
        }

        return VoiceCommandResult(
          action: finalAction,
          target: data['target'],
          readAfterNavigate: data['read_after_navigate'] ?? false,
          answer: cleanAnswer,
        );
      }
    } catch (e) {
      print('Gemini Processor Error: $e');
    }

    return VoiceCommandResult(action: VoiceAction.unknown);
  }
}