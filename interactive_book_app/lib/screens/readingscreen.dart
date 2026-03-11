 import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/content_model.dart';
import '../models/toc_model.dart'; 
import 'book_content_page.dart'; 

class ReadingScreen extends StatefulWidget {
  final BookModel book;
  final List<ContentModel> sections;
  final int initialIndex;
  final bool isArabic;

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
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      
      // الـ PageView اللي بيعمل حركة الـ Swipe (التقليب)
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.sections.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          // هنا بنعمل الـ الفصل الوهمي بالمواصفات اللي طلبها الـ TocModel بتاعك
          // بعتنا الـ id والاسم والـ depth والـ children عشان الإيرور يروح
          final tempChapter = TocModel(
            id: widget.sections[index].id, 
            name: widget.book.title, // هيعرض اسم الكتاب فوق في الـ AppBar
            depth: 0, 
            children: [],
          );

          // بنادي على صفحة صاحبتك (اللي فيها الـ AppBar والـ Drawer والترجمة)
          return BookContentPage(
            book: widget.book,
            currentChapter: tempChapter,
          );
        },
      ),

      // شريط الأسهم والعداد تحت
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12, 
            blurRadius: 4, 
            offset: const Offset(0, -2)
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // سهم الرجوع
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A0054)),
            onPressed: currentIndex > 0
                ? () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut)
                : null,
          ),
          
          // العداد (رقم الصفحة الحالي / الإجمالي)
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              "${currentIndex + 1} / ${widget.sections.length}",
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                color: Color(0xFF1A0054),
                fontSize: 18,
              ),
            ),
          ),
          
          // سهم التالي
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF1A0054)),
            onPressed: currentIndex < widget.sections.length - 1
                ? () => _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut)
                : null,
          ),
        ],
      ),
    );
  }
}