import 'package:hive/hive.dart';

Future<void> storeBookToHive(Map<String, dynamic> json) async {
  final booksBox = Hive.box('book');
  final tocBox = Hive.box('toc');
  final contentsBox = Hive.box('content');

  // 1️⃣ تخزين الكتاب نفسه
  booksBox.put(json['_id'].toString(), json);

// 2️⃣ تخزين TOC
  for (var node in json['toc']) {
    tocBox.put(node['id'].toString(), node);
  }

// 3️⃣ تخزين المحتوى
  for (var c in json['contents']) {
    contentsBox.put(c['id'].toString(), c);
  }

  print('✅ تم تخزين كل البيانات بدون مشاكل.');

}