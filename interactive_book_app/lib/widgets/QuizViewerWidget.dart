import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizViewerWidget extends StatefulWidget {
  final String jsonPath;

  const QuizViewerWidget({super.key, required this.jsonPath});

  @override
  State<QuizViewerWidget> createState() => _QuizViewerWidgetState();
}

class _QuizViewerWidgetState extends State<QuizViewerWidget> {
  int selectedOptionIndex = -1;

  Future<Map<String, dynamic>> loadQuizData() async {
    try {
      final String response = await rootBundle.loadString(widget.jsonPath);
      return json.decode(response) as Map<String, dynamic>;
    } catch (e) {
      // لو حصل أي خطأ في مسار الملف يعرضه
      return {'error_exception': e.toString()};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: loadQuizData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var quizData = snapshot.data ?? {};

        // 1. لو المسار غلط أو الملف مش قايم في الـ assets
        if (quizData.containsKey('error_exception')) {
          return Container(
            padding: const EdgeInsets.all(10),
            color: Colors.red[50],
            child: Text("❌ خطأ في تحميل الملف:\n${quizData['error_exception']}", style: const TextStyle(color: Colors.red)),
          );
        }

        var ioParameters = quizData['ioParameters'] ?? {};
        String question = ioParameters['_Question_'] ?? '';
        List<dynamic> options = ioParameters['Answers  2'] ?? [];

        // 2. كاشف الأخطاء الذكي: لو الملف فتح بس قاري بيانات فاضية أو قديمة
        if (question.isEmpty && options.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("⚠️ تنبيه: تم فتح الملف ولكن فلاتر يراه فارغاً أو بصيغة أخرى!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                const SizedBox(height: 5),
                Text("المحتوى الذي يقرأه التطبيق حالياً هو:\n${json.encode(quizData)}", style: const TextStyle(fontSize: 12, color: Colors.black87)),
              ],
            ),
          );
        }

        // 3. الكود الطبيعي في حال قراءة البيانات بنجاح
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.blueGrey[50]!,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "سؤال تفاعلي:",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                question,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Column(
                children: List.generate(options.length, (index) {
                  var option = options[index];
                  return RadioListTile<int>(
                    title: Text(option['_OptionText_'] ?? ''),
                    value: index,
                    groupValue: selectedOptionIndex,
                    onChanged: (val) {
                      setState(() {
                        selectedOptionIndex = val!;
                      });
                      if (option['_Correct_'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('إجابة صحيحة! 🎉')),
                        );
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}