import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:interactive_book_app/services/book_chat_service.dart';

import 'package:interactive_book_app/services/book_context_cache.dart';
import 'package:interactive_book_app/services/chat_history_storage.dart';
import 'package:interactive_book_app/widgets/book_mark_button.dart';
import 'package:interactive_book_app/widgets/pop_up_menu_button.dart';
import '../models/book_model.dart';
import '../models/toc_model.dart';
import '../models/content_model.dart';
import '../widgets/book_drawer.dart';
import 'package:interactive_book_app/widgets/content_section_widget.dart';

import '../screens/book_chat_screen.dart';

Future<void> openBookChat(BuildContext context, BookModel book) async {
  // استخراج النص (أو هاته من الكاش لو مستخرج قبل كذا)
  final bookContext = await BookContextCache.getOrBuildContext(book);

  // استرجاع أي محادثة محفوظة من قبل لهذا الكتاب
  final savedMessages = await ChatHistoryStorage.loadMessages(book.id);

  // إنشاء خدمة الشات، مع تمرير المحادثة القديمة عشان الموديل
  // يبدأ وهو "فاكر" كل اللي حصل قبل كذا
  final chatService = BookChatService(
    apiKey: dotenv.env['GEMINI_API_KEY']!,
    bookContext: bookContext,
    previousMessages: savedMessages,
  );

  // فتح شاشة الشات
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BookChatScreen(chatService: chatService, bookId: book.id),
    ),
  );
}

class BookContentPage extends StatefulWidget {
  final BookModel book;
  final TocModel currentChapter;
  final Function(TocModel)? onChapterSelectedInDrawer;

  const BookContentPage({
    super.key,
    required this.book,
    required this.currentChapter,
    this.onChapterSelectedInDrawer,
  });

  @override
  State<BookContentPage> createState() => _BookContentPageState();
}

class _BookContentPageState extends State<BookContentPage> {
  bool isArabic = false;
  late TocModel currentChapter;
  List<ContentModel> displaySections = [];

  @override
  void initState() {
    super.initState();
    currentChapter = widget.currentChapter;
    _loadContent(currentChapter);
  }

  void _loadContent(TocModel chapter) {
    setState(() {
      currentChapter = chapter;
      displaySections =
          widget.book.contents.where((c) => c.id == chapter.id).toList();
      if (displaySections.isEmpty && chapter.children.isNotEmpty) {
        final firstChildId = chapter.children[0].id;
        displaySections =
            widget.book.contents.where((c) => c.id == firstChildId).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0054),
        actions: [
          _buildLangBtn(),
          SizedBox(width: 24),
          BookMarkButton(
            currentChapter: currentChapter,
            bookId: widget.book.id,
          ),
          SizedBox(width: 24),
          PopUpMenuButton(book: widget.book),
        ],
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
      ),
      drawer: BookDrawer(
        book: widget.book,
        onChapterSelected: (chapter) {
          _loadContent(chapter);
          Navigator.pop(context);
          // 3. نادي الدالة اللي جاية من الأب (الـ ReadingScreen)
          if (widget.onChapterSelectedInDrawer != null) {
            widget.onChapterSelectedInDrawer!(chapter);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A0054),
        onPressed: () => openBookChat(context, widget.book),
        // tooltip: 'اسأل عن الكتاب',
        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 16, bottom: 12),
            child: Text(
              currentChapter.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A0054),
              ),
            ),
          ),
          Divider(
            color: Colors.grey[400],
            thickness: 1,
            endIndent: 20,
            indent: 20,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: displaySections.length,
              itemBuilder:
                  (context, index) => ContentSectionWidget(
                    section: displaySections[index],
                    isArabic: isArabic,
                    onRefresh: () => setState(() {}),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLangBtn() => TextButton(
    onPressed: () => setState(() => isArabic = !isArabic),
    child: Row(
      children: [
        Icon(Icons.translate, color: Colors.white, size: 28),
        SizedBox(width: 8),
        Text(
          isArabic ? "AR" : "EN",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
