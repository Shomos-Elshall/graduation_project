 import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/content_model.dart';
import '../widgets/content_section_widget.dart';

/// [ReadingScreen] هي الشاشة المسؤولة عن عرض محتوى الكتاب بشكل صفحات قابلة للتقليب.
/// تستخدم هذه الشاشة [PageView] لتمكين المستخدم من السحب (Swipe) يمين ويسار.
class ReadingScreen extends StatefulWidget {
  final BookModel book;           // كائن الكتاب اللي جاي من قاعدة البيانات (Hive)
  final List<ContentModel> sections; // قائمة الصفحات أو المحتويات المراد عرضها
  final int initialIndex;        // الصفحة اللي هيبدأ من عندها (غالباً صفر)
  final bool isArabic;           // متغير لتحديد لغة العرض (عربي/إنجليزي)

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
  // [PageController] هو المحرك المسؤول عن التحكم في حركة الصفحات والقفز لصفحة معينة
  late PageController _pageController;
  
  // [currentIndex] متغير بيحفظ رقم الصفحة اللي الطالب واقف عليها حالياً
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    // بنعرف الـ Controller ونخليه يبدأ من الصفحة المحددة
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      
      // الـ body عبارة عن PageView وده اللي بيعمل ميزة "تقليب الصفحات"
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.sections.length, // عدد الصفحات الكلي
        onPageChanged: (index) {
          // دالة بتشتغل كل ما الطالب يقلب الصفحة عشان نحدث رقم الصفحة تحت
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          // هنا بنعرض "الويجدت" بتاعك الأصلي لكل صفحة
          return SingleChildScrollView(
            child: ContentSectionWidget(
              section: widget.sections[index], // بيانات الصفحة الحالية
              isArabic: widget.isArabic,       // اللغة المختارة
              onRefresh: () => setState(() {}), // تحديث الواجهة عند حدوث تغيير (تظليل مثلاً)
            ),
          );
        },
      ),

      // شريط التنقل السفلي اللي فيه الأسهم والعداد
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  /// دالة [_buildBottomNav] مسؤولة عن بناء شريط التحكم (الأسهم ورقم الصفحة)
  Widget _buildBottomNav() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // زرار الصفحة السابقة
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A0054)),
            onPressed: currentIndex > 0
                ? () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut)
                : null, // الزرار بيطفي لو إحنا في أول صفحة
          ),
          
          // نص بيعرض الصفحة الحالية من الإجمالي
          Text(
            "صفحة ${currentIndex + 1} من ${widget.sections.length}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF1A0054)),
          ),
          
          // زرار الصفحة التالية
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF1A0054)),
            onPressed: currentIndex < widget.sections.length - 1
                ? () => _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut)
                : null, // الزرار بيطفي لو إحنا في آخر صفحة
          ),
        ],
      ),
    );
  }
}