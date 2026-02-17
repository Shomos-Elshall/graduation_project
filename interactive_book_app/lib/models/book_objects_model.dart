import 'package:hive/hive.dart';
part 'book_objects_model.g.dart';

@HiveType(typeId: 4)
class BookObjects extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String language;
  @HiveField(3)
  final String url;
  @HiveField(4)
  // final String h5pType;
  // @HiveField(5)
  BookObjects({
    required this.id,
    required this.title,
    required this.language,
    required this.url,
    // required this.h5pType,
  });

  factory BookObjects.fromJson(Map<String, dynamic> json) {
    return BookObjects(
      id: json['_id'] as String,
      title: json['title'] as String,
      language: json['language'] as String,
      url: json['url'] as String,
      // h5pType: json['h5pType'] as String ?? " ",
    );
  }
}
