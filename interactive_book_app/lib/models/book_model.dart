import 'package:hive/hive.dart';
import 'package:interactive_book_app/models/book_objects_model.dart';
import 'package:interactive_book_app/models/content_model.dart';
import 'package:interactive_book_app/models/glossary_model.dart';
import 'package:interactive_book_app/models/toc_model.dart';

part 'book_model.g.dart';

@HiveType(typeId: 0)
class BookModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;
  @HiveField(2)
  final String coverPageURL;
  @HiveField(3)
  final String contentsURL;
  @HiveField(4)
  final String glossaryURL;
  @HiveField(5)
  final List<String> authors;
  @HiveField(6)
  final List<TocModel> toc;
  @HiveField(7)
  final List<BookObjects> bookObjects;
  @HiveField(8)
  final List<ContentModel> contents;
  @HiveField(9)
  final List<GlossaryModel> glossary;

  BookModel({
    required this.id,
    required this.title,
    required this.coverPageURL,
    required this.contentsURL,
    required this.glossaryURL,
    required this.authors,
    required this.toc,
    required this.bookObjects,
    required this.contents,
    required this.glossary,
  });
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      coverPageURL: json['coverPageURL'] as String,
      contentsURL: json['contentsURL'] as String,
      glossaryURL: json['glossaryURL'] as String,
      authors: List<String>.from(json['authors'] as List),
      toc:
          json['toc'] == null
              ? []
              : (json['toc'] as List).map((e) => TocModel.fromJson(e)).toList(),
      bookObjects:
          (json['bookObjects'] as List)
              .map((item) => BookObjects.fromJson(item as Map<String, dynamic>))
              .toList(),
      contents:
          (json['contents'] as List)
              .map(
                (item) => ContentModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      glossary:
          (json['glossary'] as List)
              .map(
                (item) => GlossaryModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  @override
  String toString() {
    return 'BookModel{id: $id, title: $title, ';
  }
}
