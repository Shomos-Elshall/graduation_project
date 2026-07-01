/*import 'package:flutter/material.dart';
import '../services/book_chat_service.dart';
import '../services/chat_history_storage.dart';
// استدعاء ملف الكويز (تأكدي إن المسار صح حسب مشروعك)
import '../widgets/quiz_options_bottom_sheet.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class BookChatScreen extends StatefulWidget {
  final BookChatService chatService;
  final String bookId;

  const BookChatScreen({
    required this.chatService,
    required this.bookId,
    super.key,
  });

  @override
  State<BookChatScreen> createState() => _BookChatScreenState();
}

class _BookChatScreenState extends State<BookChatScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadSavedMessages();
  }

  /// يجيب أي محادثة محفوظة من قبل لهذا الكتاب ويعرضها فورًا
  Future<void> _loadSavedMessages() async {
    final saved = await ChatHistoryStorage.loadMessages(widget.bookId);
    setState(() {
      _messages.addAll(saved);
      _isLoadingHistory = false;
    });
  }

  /// يحفظ كل الرسائل الحالية بعد أي تحديث (سؤال جديد أو رد جديد)
  Future<void> _persistMessages() async {
    await ChatHistoryStorage.saveMessages(widget.bookId, _messages);
  }

  // دالة صاحبتك الأصلية فضلنا محافظين عليها زي ما هي بالظبط
  Future<void> _send() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': question});
      _isLoading = true;
      _controller.clear();
    });
    await _persistMessages();

    try {
      final answer = await widget.chatService.askQuestion(question);
      setState(() => _messages.add({'role': 'bot', 'text': answer}));
    } catch (e) {
      setState(
        () => _messages.add({'role': 'bot', 'text': 'حدث خطأ، حاول مرة أخرى.'}),
      );
    } finally {
      setState(() => _isLoading = false);
      await _persistMessages();
    }
  }

  // --- الدالة الجديدة اللي ضفناها عشان الكويز بس ---
  Future<void> _sendQuizPrompt(String prompt) async {
    setState(() {
      _messages.add({
        'role': 'user',
        'text': "Generate a new quiz based on my settings 📝",
      });
      _isLoading = true;
    });
    await _persistMessages();

    try {
      final answer = await widget.chatService.askQuestion(prompt);
      setState(() => _messages.add({'role': 'bot', 'text': answer}));
    } catch (e) {
      setState(
        () => _messages.add({'role': 'bot', 'text': 'حدث خطأ، حاول مرة أخرى.'}),
      );
    } finally {
      setState(() => _isLoading = false);
      await _persistMessages();
    }
  }
  // ------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (_isLoadingHistory) {
      return Scaffold(
        appBar: AppBar(title: const Text('اسأل عن الكتاب')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1A0054),
        title: const Text(
          "Ask Gemini , Your Book Assistant",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ?  const Color(0xFF1A0054) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                   // التعديل هنا: فصل رسالة المستخدم عن رسالة البوت
                    child: isUser
                        ? Text(
                            msg['text'] ?? '',
                            style: const TextStyle(
                              color: Colors.white, // لون أبيض صريح لرسالتك
                              fontSize: 16,
                            ),
                          )
                        : MarkdownBody(
                            data: msg['text'] ?? '',
                            styleSheet: MarkdownStyleSheet(
                              p: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ), // نص السؤال أو الرد العادي
                              strong: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ), // للخيارات والخط العريض
                              h3: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A0054),
                              ), // للعناوين
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: Row(
              children: [
                // --- الزرار الجديد بتاع الكويز اللي ضفناه ---
                IconButton(
                  icon: const Icon(
                    Icons.assignment_turned_in,
                    color: Color(0xFF1A0054),
                    size: 28,
                  ),
                  tooltip: "إنشاء اختبار",
                  onPressed:
                      _isLoading
                          ? null
                          : () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return QuizOptionsBottomSheet(
                                  onGenerateQuiz: (prompt) {
                                    _sendQuizPrompt(
                                      prompt,
                                    ); // استدعاء الدالة الجديدة
                                  },
                                );
                              },
                            );
                          },
                ),
                const SizedBox(width: 8),
                // --------------------------------------------
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Write your question here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color(0xFF1A0054),
                    size: 28,
                  ),
                  onPressed: _isLoading ? null : _send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import '../services/book_chat_service.dart';
import '../services/chat_history_storage.dart';
// استدعاء ملف الكويز (تأكدي إن المسار صح حسب مشروعك)
import '../widgets/quiz_options_bottom_sheet.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class BookChatScreen extends StatefulWidget {
  final BookChatService chatService;
  final String bookId;

  const BookChatScreen({
    required this.chatService,
    required this.bookId,
    super.key,
  });

  @override
  State<BookChatScreen> createState() => _BookChatScreenState();
}

class _BookChatScreenState extends State<BookChatScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // 1. إضافة الـ ScrollController
  bool _isLoading = false;
  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadSavedMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // دالة النزول التلقائي لأسفل الشات
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// يجيب أي محادثة محفوظة من قبل لهذا الكتاب ويعرضها فورًا
  Future<void> _loadSavedMessages() async {
    final saved = await ChatHistoryStorage.loadMessages(widget.bookId);
    setState(() {
      _messages.addAll(saved);
      _isLoadingHistory = false;
    });
    _scrollToBottom(); // النزول لتحت بعد تحميل المحادثة
  }

  /// يحفظ كل الرسائل الحالية بعد أي تحديث (سؤال جديد أو رد جديد)
  Future<void> _persistMessages() async {
    await ChatHistoryStorage.saveMessages(widget.bookId, _messages);
  }

  Future<void> _send() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': question});
      _isLoading = true;
      _controller.clear();
    });
    _scrollToBottom(); // النزول لتحت بعد إرسال السؤال
    await _persistMessages();

    try {
      final answer = await widget.chatService.askQuestion(question);
      setState(() => _messages.add({'role': 'bot', 'text': answer}));
    } catch (e) {
      setState(
        () => _messages.add({'role': 'bot', 'text': 'حدث خطأ، حاول مرة أخرى.'}),
      );
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom(); // النزول لتحت بعد استلام الرد
      await _persistMessages();
    }
  }

  // --- الدالة الجديدة اللي ضفناها عشان الكويز بس ---
  Future<void> _sendQuizPrompt(String prompt) async {
    setState(() {
      _messages.add({
        'role': 'user',
        'text': "Generate a new quiz based on my settings 📝",
      });
      _isLoading = true;
    });
    _scrollToBottom(); // النزول لتحت بعد طلب الاختبار
    await _persistMessages();

    try {
      final answer = await widget.chatService.askQuestion(prompt);
      setState(() => _messages.add({'role': 'bot', 'text': answer}));
    } catch (e) {
      setState(
        () => _messages.add({'role': 'bot', 'text': 'حدث خطأ، حاول مرة أخرى.'}),
      );
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom(); // النزول لتحت بعد ظهور الاختبار
      await _persistMessages();
    }
  }
  // ------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (_isLoadingHistory) {
      return Scaffold(
        appBar: AppBar(title: const Text('اسأل عن الكتاب')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1A0054),
        title: const Text(
          "Ask Gemini , Your Book Assistant",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // 2. ربط الـ Controller بالقائمة
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  // 3. إضافة GestureDetector لاكتشاف الضغطة المطولة
                  child: GestureDetector(
                    onLongPress: () {
                      if (!isUser) { // لو كانت رسالة البوت
                        setState(() {
                          _controller.text = "Please explain this part in details:\n\n${msg['text']}";
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: isUser ? const Color(0xFF1A0054) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: isUser
                          ? SelectableText( // 4. تحويل النص لـ SelectableText عشان تقدري تنسخيه
                              msg['text'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )
                          : MarkdownBody(
                              selectable: true, // 5. جعل الـ Markdown قابل للتحديد
                              data: msg['text'] ?? '',
                              styleSheet: MarkdownStyleSheet(
                                p: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                strong: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                h3: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A0054),
                                ),
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.assignment_turned_in,
                    color: Color(0xFF1A0054),
                    size: 28,
                  ),
                  tooltip: "إنشاء اختبار",
                  onPressed:
                      _isLoading
                          ? null
                          : () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return QuizOptionsBottomSheet(
                                    onGenerateQuiz: (prompt) {
                                      _sendQuizPrompt(
                                        prompt,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Write your question here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color(0xFF1A0054),
                    size: 28,
                  ),
                  onPressed: _isLoading ? null : _send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

 
