import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/book_model.dart';
import '../models/toc_model.dart';
import 'book_content_page.dart';

class BookmarksScreen extends StatelessWidget {
  final BookModel book;

  const BookmarksScreen({super.key, required this.book});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saved chapters")),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<TocModel>('bookmarks_box').listenable(),
        builder: (context, Box<TocModel> box, _) {
          // جلب كل البيانات المخزنة في الصندوق وتحويلها لقائمة
          final bookmarkedChapters = box.values.toList();

          if (bookmarkedChapters.isEmpty) {
            return Center(child: Text("The bookmark list is empty"));
          }

          return ListView.builder(
            itemCount: bookmarkedChapters.length,
            itemBuilder: (context, index) {
              final chapter = bookmarkedChapters[index];
              return ListTile(
                leading: Icon(Icons.book, color: Colors.blue),
                title: Text(chapter.name), // هنا يظهر اسم الشابتر
                subtitle: Text("Click to go"),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey,size: 30,),
                  onPressed: () => box.delete(chapter.id.toString()),
                ),
                onTap: () {
                  // هنا ضعي كود الانتقال للشابتر عند الضغط عليه
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookContentPage(
                        book: book,              // ده الكتاب اللي استقبلناه في الشاشة دي
                        currentChapter: chapter, // ده الشابتر المرجعي اللي المستخدم داس عليه
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}