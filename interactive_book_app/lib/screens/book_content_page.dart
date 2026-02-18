import 'package:flutter/material.dart';
import 'package:interactive_book_app/models/book_model.dart';
import 'package:interactive_book_app/models/toc_model.dart';

class BookContentPage extends StatefulWidget {
  final BookModel book;

  const BookContentPage({super.key, required this.book});

  @override
  State<BookContentPage> createState() => _BookContentPageState();
}

class _BookContentPageState extends State<BookContentPage> {
  // متغير لحفظ الفصل الحالي المعروض في الصفحة
  TocModel? currentChapter;

  @override
  void initState() {
    super.initState();
    // افتراضياً نعرض أول فصل في الكتاب عند الفتح
    if (widget.book.toc != null && widget.book.toc!.isNotEmpty) {
      currentChapter = widget.book.toc![0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        backgroundColor: const Color(0xFF1D0E53),
      ),
      // إضافة الدرور هنا
      drawer: _buildBookDrawer(context),
      body: currentChapter == null
          ? const Center(child: Text("اختر فصلاً من القائمة الجانبية"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
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
              const Divider(thickness: 2),
              const SizedBox(height: 10),
              // عرض النص الخاص بالفصل (TextContent)
              Text(
                currentChapter!.text?.en ?? "لا يوجد محتوى متاح لهذا العنوان.",
                style: const TextStyle(fontSize: 18, height: 1.6),
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
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // قائمة الشباتر والعناوين
          Expanded(
            child: ListView.builder(
              itemCount: widget.book.toc?.length ?? 0,
              itemBuilder: (context, index) {
                return _buildTocEntry(widget.book.toc![index]);
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
    if (item.children != null && item.children!.isNotEmpty) {
      return ExpansionTile(
        leading: const Icon(Icons.book, color: Color(0xFF1D0E53)),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: item.children!.map((child) => _buildTocEntry(child)).toList(),
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
