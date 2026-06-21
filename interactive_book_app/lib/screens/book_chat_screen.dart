// ضع هذا الملف في: lib/screens/book_chat_screen.dart
//
// المسؤولية: واجهة الشات نفسها (عرض الرسائل + مربع كتابة السؤال)
// + استرجاع المحادثة المحفوظة من قبل لهذا الكتاب، وحفظ أي رسالة جديدة
// فورًا عشان المحادثة متفضلش موجودة حتى لو المستخدم قفل الشاشة.

import 'package:flutter/material.dart';
import '../services/book_chat_service.dart';
import '../services/chat_history_storage.dart';

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
                        color: isUser ? Colors.blue[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(msg['text'] ?? ''),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 24),
              child: Row(
                children: [
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
                    icon: const Icon(Icons.send , color: Color(0xFF1A0054), size: 28),
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
