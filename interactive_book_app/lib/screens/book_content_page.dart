import 'package:flutter/material.dart';
import 'package:interactive_book_app/models/book_model.dart';
import 'package:interactive_book_app/models/toc_model.dart';
import 'package:flutter_html/flutter_html.dart';

class BookContentPage extends StatefulWidget {
  final BookModel book;

  const BookContentPage({super.key, required this.book});

  @override
  State<BookContentPage> createState() => _BookContentPageState();
}

class _BookContentPageState extends State<BookContentPage> {
  // متغير لحفظ الفصل الحالي المعروض في الصفح
  TocModel? currentChapter;

  @override
  void initState() {
    super.initState();
    // افتراضياً نعرض أول فصل في الكتاب عند الفتح
    if (widget.book.toc.isNotEmpty) {
      currentChapter = widget.book.toc[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1A0054),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Image.asset(
            "assets/images/image 1 (1).png",
            width: 170,
            height: 130,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.blueAccent,
          size: 30,
        ), // حطي اللون اللي تحبيه هنا
      ),

      // إضافة الدرور هنا
      drawer: _buildBookDrawer(context),
      body:
          currentChapter == null
              ? const Center(child: Text("اختر فصلاً من القائمة الجانبية"))
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentChapter!.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D0E53),
                        ),
                      ),
                      Divider(
                        height: 40,
                        thickness: 1,
                        color: Color(
                          0xFF1A0054,
                        ).withOpacity(0.1), // لون نيفي شفاف جداً
                        indent: 20, // مسافة بادئة من الشمال
                        endIndent:
                            20, // مسافة من اليمين عشان ميبقاش لازق في الحواف
                      ),
                      const SizedBox(height: 6),

                      // عرض النص الخاص بالفصل (TextContent)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Html(
                          data:
                              currentChapter!.text?.en ??
                              "<p>No content available</p>",
                          style: {
                            // تنسيق الباراجراف العام
                            "p": Style(
                              fontSize: FontSize(20.0),
                              lineHeight: LineHeight(
                                1.6,
                              ), // مسافة مريحة بين السطور
                              color: Colors.black87,
                              margin: Margins.only(bottom: 12),
                              textAlign:
                                  TextAlign
                                      .justify, // مساواة السطور من الجانبين
                            ),
                            // تنسيق الكلام اللي معموله Bold
                            "strong": Style(
                              color: const Color(0xFF1A0054),
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize(24.0),
                            ),
                            // تنسيق القوائم لو موجودة
                            "li": Style(
                              margin: Margins.only(bottom: 8),
                              fontSize: FontSize(17.0),
                            ),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  // بناء الـ Drawer
  Widget _buildBookDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // رأس الدرور فيه اسم الكتاب
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF1D0E53)),
            child: Center(
              child: Text(
                widget.book.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // قائمة الشباتر والعناوين
          Expanded(
            child: ListView.builder(
              itemCount: widget.book.toc.length,
              itemBuilder: (context, index) {
                return _buildTocEntry(widget.book.toc[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // دالة لبناء عناصر الفهرس بشكل تكراري (Recursive) لدعم العناوين الفرعية
  Widget _buildTocEntry(TocModel item) {
    // إذا كان العنوان يحتوي على أبناء (Children)
    if (item.children.isNotEmpty) {
      return ExpansionTile(
        leading: const Icon(Icons.book, color: Color(0xFF1D0E53)),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: item.children.map((child) => _buildTocEntry(child)).toList(),
      );
    } else {
      // إذا كان عنوان نهائي (لا يوجد تحته عناوين فرعية)
      return ListTile(
        contentPadding: const EdgeInsets.only(left: 32, right: 16),
        leading: const Icon(Icons.label_important_outline, size: 20),
        title: Text(item.name),
        onTap: () {
          setState(() {
            currentChapter = item; // تحديث المحتوى المعروض
          });
          Navigator.pop(context); // إغلاق الدرور بعد الاختيار
        },
      );
    }
  }
}
