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

  BookObjects({
    required this.id,
    required this.title,
    required this.language,
    required this.url,
  });

}