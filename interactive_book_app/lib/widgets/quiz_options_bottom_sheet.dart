import 'package:flutter/material.dart';

class QuizOptionsBottomSheet extends StatefulWidget {
  // دي الدالة اللي هترجع الـ Prompt للشاشة الأساسية عشان تتبعت لـ Gemini
  final void Function(String prompt) onGenerateQuiz;

  const QuizOptionsBottomSheet({super.key, required this.onGenerateQuiz});

  @override
  State<QuizOptionsBottomSheet> createState() => _QuizOptionsBottomSheetState();
}

class _QuizOptionsBottomSheetState extends State<QuizOptionsBottomSheet> {
  int selectedCount = 5;
  String selectedType = 'MCQ';

  final List<String> questionTypes = [
    'MCQ',
    'True or False',
    'Short Answer',
    'Fill in the Blanks',
  ];

  final List<int> questionCounts = [3, 5, 10, 15];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مؤشر السحب (Drag Handle)
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A0054).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFF1A0054),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Generate Quiz",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A0054),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 28),

            const Text(
              "Question Type",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 12,
              children:
                  questionTypes.map((type) {
                    final isSelected = selectedType == type;
                    return ChoiceChip(
                      showCheckmark: false,
                      selected: isSelected,
                      selectedColor: const Color(0xFF1A0054),
                      backgroundColor: Colors.grey.shade100,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? const Color(0xFF1A0054)
                                  : Colors.transparent,
                        ),
                      ),
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected)
                            const Padding(
                              padding: EdgeInsets.only(right: 6),
                              child: Icon(
                                Icons.auto_awesome,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          Text(
                            type,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      onSelected: (selected) {
                        setState(() => selectedType = type);
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 32),

            const Text(
              "Number of Questions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children:
                  questionCounts.map((count) {
                    final isSelected = selectedCount == count;
                    return GestureDetector(
                      onTap: () => setState(() => selectedCount = count),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isSelected
                                  ? const Color(0xFF1A0054)
                                  : Colors.white,
                          border: Border.all(
                            color:
                                isSelected
                                    ? const Color(0xFF1A0054)
                                    : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          boxShadow:
                              isSelected
                                  ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF1A0054,
                                      ).withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                  : [],
                        ),
                        child: Text(
                          "$count",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A0054),
                  elevation: 4,
                  shadowColor: const Color(0xFF1A0054).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // نقفل الـ Bottom Sheet

                  // نجهز الـ Prompt بناءً على الاختيارات
                  final prompt = """
You are an expert academic examiner. Generate a quiz based strictly on the provided book content.

Rules for the quiz:
1. Introduction: Write a VERY brief, professional, and encouraging one-sentence introduction welcoming the student.
2. Questions: Generate exactly $selectedCount questions of type: "$selectedType".
3. Language: English only.
4. DO NOT PROVIDE THE ANSWERS INITIALLY. Only ask the questions and wait for the student to reply in the chat.
5. Formatting: You MUST format the output using Markdown:
   - Use ### for the main quiz title.
   - Use **bold** for every question.
   - Use a numbered list (1., 2., 3.) for the questions.
   - Use a bulleted list (- ) for the options if it is an MCQ.

Grading Rules (When the student replies later):
- Carefully grade their answers and provide a final score (e.g., Score: X/$selectedCount).
- CRITICAL: If the student gets a perfect score (answers all questions correctly), you MUST include a highly encouraging, celebratory, and praiseful statement to reward their excellent performance.
- Explicitly show the correct answers with brief explanations from the book's context.

Now, present the quiz.
""";
                  // نبعت الـ Prompt للشاشة الأصلية
                  widget.onGenerateQuiz(prompt);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.psychology, color: Colors.white, size: 24),
                    SizedBox(width: 8),
                    Text(
                      "Start Generating",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
