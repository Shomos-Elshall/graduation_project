 import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/content_model.dart';
import 'book_content_page.dart'; // تأكدي إن المسار ده صح لصفحتك الأصلية

class ReadingScreen extends StatefulWidget {
  final BookModel book;
  final List<ContentModel> sections; // المحتوى اللي جاي من الـ Navigator
  final int initialIndex; // صفحة البداية
  final bool isArabic; // اللغة

  const ReadingScreen({
    super.key,
    required this.book,
    required this.sections,
    required this.isArabic,
    this.initialIndex = 0,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    // بنخلي العداد والمحرك يبدأوا من الصفحة اللي جات من الـ Navigator (غالباً صفر)
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. الجزء اللي فوق وفي النص (بيعرض صفحتك الأصلية)
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.sections.length,
        onPageChanged: (index) {
          // لما الطالب يسحب الشاشة يمين أو شمال، بنحدث العداد اللي تحت
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          // بنستدعي صفحتك الأصلية بكل مكوناتها (AppBar, Drawer, Content)
          return BookContentPage(
            book: widget.book,
            // بنبعت الفصل أو السيكشن المناسب لرقم الصفحة الحالي
            currentChapter: widget.book.toc[index], 
          );
        },
      ),

      // 2. الجزء اللي تحت (شريط الأسهم والعداد)
      bottomNavigationBar: Container(
        height: 70, // ارتفاع الشريط
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12, 
              blurRadius: 6, 
              offset: Offset(0, -2), // ظل خفيف لفوق عشان يفصل عن المحتوى
            )
          ],
        ),
        child: SafeArea( // عشان الزراير متخبطش في شريط زراير الموبايل اللي تحت
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // --- زرار الصفحة السابقة ---
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A0054)),
                onPressed: currentIndex > 0
                    ? () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null, // بيقفل الزرار لو إحنا في أول صفحة
              ),

              // --- عداد الصفحات ---
              Text(
                "صفحة ${currentIndex + 1} من ${widget.sections.length}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1A0054),
                ),
              ),

              // --- زرار الصفحة التالية ---
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF1A0054)),
                onPressed: currentIndex < widget.sections.length - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null, // بيقفل الزرار لو إحنا في آخر صفحة
              ),
            ],
          ),
        ),
      ),
    );
  }
}